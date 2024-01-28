class InsuranceService < ApplicationService
    def initialize
    end

    # add on insurance on existing order
    def self.order_add_fw(order: nil, fw_id: nil, fee: Fee.find_by(code: "INSURANCE_GROSS_PREMIUM"))
        # pending order check
        pending_order = OrderItem.select("orders.code order_code, orders.status order_status, fw.code fw_code, fw.name fw_name")
        .joins("join orders on order_items.order_id = orders.id join fees on order_items.fee_id = fees.id
        join foreign_workers fw on order_items.order_itemable_id = fw.id and order_items.order_itemable_type = 'ForeignWorker'")
        .where("orders.status" => ["NEW", "PENDING_PAYMENT", "PENDING_AUTHORIZATION", "PENDING"])
        .where("fees.code" => ["INSURANCE_GROSS_PREMIUM"])
        .where("fw.id = ?", fw_id)
        .where.not("orders.id" => order.id).first
        if pending_order
            return "#{pending_order.fw_name} has pending order (#{pending_order.order_code})"
        end
        # /pending order check

        # repeat purchase check
        fw = ForeignWorker.find(fw_id)

        # Remove this check SR20220109
        # day_before_expiry = SystemConfiguration.get('INSURANCE_EXPIRY_GRACE').to_i
        # pending_order = InsurancePurchaseItem.joins(:insurance_purchase).joins(insurance_purchase: :order)
        # .select("orders.code order_code")
        # .where("insurance_purchases.foreign_worker_id" => fw_id)
        # .where("insurance_purchase_items.policy_status" => "ACTIVE")
        # .where("insurance_purchase_items.end_date > ?", day_before_expiry.day.from_now.beginning_of_day).first
        # if pending_order
        #     return "Re-purchase insurance is not allowed. #{fw.name} has active insurance policy (#{pending_order.order_code})"
        # end

        # pending_order = InsurancePurchase.left_joins(:insurance_purchase_items).joins(:order)
        # .select("orders.code order_code")
        # .where("insurance_purchases.foreign_worker_id" => fw_id)
        # .where("insurance_purchase_items.id is null")
        # .where("orders.status" => ["PAID"]).first
        # if pending_order
        #     return "Re-purchase insurance is not allowed. #{fw.name} has pending insurance policy (#{pending_order.order_code})"
        # end
        # /repeat purchase check

        # worker's employer check
        if order.customerable_type == 'Agency'
            fw_order_items = order&.order_items&.where(order_itemable_type: 'ForeignWorker')
            fw_order_items.try(:each) do |fw_order_item|
                foreign_worker = fw_order_item.order_itemable
                if foreign_worker.employer_id != fw.employer_id
                    return "#{fw.name} - Employer not match"
                end
            end
        else
            if order.customerable_id != fw.employer_id
                return "#{fw.name} - Employer not match"
            end
        end
        # /worker's employer check

        # paid order check
        if ["PENDING", "PENDING_AUTHORIZATION", "PAID", "CANCELLED", "FAILED"].include?(order.status)
            return "Order #{order.code} is #{order.status}"
        end
        # /paid order check

        oi = order.order_items.where({
            order_itemable_id: fw_id,
            order_itemable_type: 'ForeignWorker',
            fee_id: fee.id,
        }).first_or_create do |oi|
            oi.update({
                amount: fee.amount,
                gender: fw.gender
            })
        end

    end
    # /order_add_fw

    # clear order_items' sst and stamp duty, insurance_purchases if no more insurance premium
    def self.order_clear_insurance(order: nil)
        if order.order_items.joins(:fee).where("fees.code" => ["INSURANCE_GROSS_PREMIUM"]).count == 0
            order.order_items.joins(:fee).where("fees.code" => ["INSURANCE_SST", "INSURANCE_STAMP_DUTY", "INSURANCE_ADMINFEES", "INSURANCE_ADMINFEES_SST"]).destroy_all
            order.insurance_purchases.destroy_all
            order.update({
                insurance_service_provider_id: nil
            })
        end
    end
    # /order_clear_insurance

    # check if require premium re-calculation
    def self.order_need_recalculate?(order: nil)
        OrderItem.where(order_id: order.id).or(InsurancePurchase.where(order_id: order.id)).joins("join fees on order_items.fee_id = fees.id and fees.code in ('INSURANCE_GROSS_PREMIUM')
        full join insurance_purchases on order_items.id = insurance_purchases.order_item_id and order_items.order_id = insurance_purchases.order_id
        left join foreign_workers on insurance_purchases.foreign_worker_id = foreign_workers.id")
        .select("order_items.id order_item_id, order_items.amount order_item_amount, insurance_purchases.id insurance_purchase_id, insurance_purchases.fw_gender insurance_purchase_fw_gender, insurance_purchases.fw_country_id insurance_purchase_fw_country_id, foreign_workers.gender foreign_worker_gender, foreign_workers.country_id foreign_worker_country_id").each do |oi|
            return true if !oi.order_item_id? || !oi.order_item_amount? || !oi.insurance_purchase_id? || oi.insurance_purchase_fw_country_id != oi.foreign_worker_country_id || oi.insurance_purchase_fw_gender != oi.foreign_worker_gender
        end

        return true if order.insurance_purchases.first&.insurance_service_provider&.code != order.insurance_service_provider&.code

        return false
    end
    # /order_need_recalculate

    # check if paid and require submit paid info
    def self.order_paid_pending_submit?(order: nil)
        Order.joins(:insurance_purchases).where(id: order.id).where(status: "PAID").where("insurance_purchases.status" => [nil, ""]).count > 0
    end
    # /order_paid_pending_submit?

    # check if order has insurance item
    def self.order_has_insurance?(order: nil)
        OrderItem.joins(:order).joins(:fee).where(order_id: order.id).where("fees.code" => "INSURANCE_GROSS_PREMIUM").count > 0
    end
    # /order_has_insurance?

    # return data to be submitted to calculator
    def self.calculator_submit_data(order: nil, response_url: nil, backend_url: nil)
        if order.customerable_type == 'Agency'
            employer = order.order_items.where({order_itemable_type: "ForeignWorker"}).first.order_itemable.employer
            agency_ret = {
                AGENT_CODE: order.customerable.code,
                AGENT_EMAIL: order.customerable.email,
            }
        else
            employer = order.customerable
            agency_ret = {}
        end

        ret = {
            ORDER_CODE: order.code,
            EMPLOYER_CODE: employer.code,
            EMPLOYER_TYPE: employer.employer_type_id,
            EMPLOYER_EMAIL: employer.email,
            CONTACT_PERSON: order.customerable.pic_name || '',
            RESPONSE_URL: response_url,
            BACKEND_URL: backend_url,
            WORKER_LIST: [],
        }

        ret = ret.merge(agency_ret)

        order.order_items.joins("join foreign_workers fw on order_items.order_itemable_id = fw.id and order_items.order_itemable_type = 'ForeignWorker'
        join fees f on order_items.fee_id = f.id and f.code = 'INSURANCE_GROSS_PREMIUM'
        join countries c on fw.country_id = c.id
        join job_types jt on fw.job_type_id = jt.id")
        .select("fw.id worker_id, fw.name worker_name, fw.passport_number passport_no, c.code country_code, fw.gender, fw.date_of_birth, jt.name job_type")
        .each do |row|
            ret[:WORKER_LIST] << {
                WORKER_ID: row.worker_id,
                WORKER_NAME: row.worker_name,
                PASSPORT_NO: row.passport_no,
                COUNTRY_CODE: row.country_code,
                GENDER: row.gender,
                DATE_OF_BIRTH: row.date_of_birth.strftime("%d/%m/%Y"),
                JOB_TYPE: row.job_type,
            }
        end

        return ret
    end
    # /calculator_submit_data

    # save calculated premium
    def self.save_calculated_premium(data: nil, provider_code: nil)
        data = JSON.parse(data)
        provider_code = provider_code || "HOWDEN"

        order = Order.find_by(code: data["ORDER_CODE"])
        raise ActionController::RoutingError.new('Order Not Found') if !order
        raise ActionController::RoutingError.new('Order Not Allowed to Update') if ["PENDING", "PENDING_AUTHORIZATION", "PAID", "CANCELLED", "FAILED"].include?(order.status)

        fee_insurance_gross_premium = Fee.find_by(code: "INSURANCE_GROSS_PREMIUM")
        worker_ids = []
        order_item_ids = []

        # premium
        data["WORKER_LIST"].each do |worker|
            next if worker["TOTAL_PREMIUM"].to_f == 0
            oi = order.order_items.where({
                order_itemable_id: worker["WORKER_ID"],
                order_itemable_type: "ForeignWorker",
                fee_id: fee_insurance_gross_premium.id,
            }).first_or_create
            oi.update({
                amount: worker["GROSS_PREMIUM"].to_s.remove(',').to_f,
                gender: worker["GENDER"],
            })
            insurance_purchase = oi.insurance_purchase
            if insurance_purchase.nil?
                insurance_purchase = InsurancePurchase.new({
                    order_item_id: oi.id
                })
            end

            insurance_purchase.update({
                order_id: oi.order_id,
                product_purchased: worker["INS_PRODUCT"],
                insurance_provider: worker["INSURER"],
                gross_premium: worker["GROSS_PREMIUM"],
                employer_id: oi.order_itemable.employer_id,
                # emp_code: oi.order.customerable.code,
                # emp_name: oi.order.customerable.name,
                emp_code: oi.order_itemable.employer&.code,
                emp_name: oi.order_itemable.employer&.name,
                foreign_worker_id: oi.order_itemable_id,
                fw_code: oi.order_itemable.code,
                fw_name: worker["WORKER_NAME"],
                fw_gender: worker["GENDER"],
                fw_date_of_birth: worker["DATE_OF_BIRTH"],
                fw_passport_number: worker["PASSPORT_NO"],
                fw_country_id: Country.where(code: worker["COUNTRY_CODE"]).first.id,
                fw_job_type_id: JobType.where(name: worker["JOB_TYPE"]).first.id,
                stamp_duty: worker["STAMP_DUTY"].to_s.remove(',').to_f,
                sst: worker["SST"].to_s.remove(',').to_f,
                adminfees: worker["ADMINFEES"].to_s.remove(',').to_f,
                adminfees_sst: worker["ADMINFEES_SST"].to_s.remove(',').to_f,
                total_premium: worker["TOTAL_PREMIUM"].to_s.remove(',').to_f,
                insurance_service_provider_id: InsuranceServiceProvider.where(code: provider_code).first.id,
            })

            worker_ids << oi.order_itemable_id
            order_item_ids << oi.id
        end
        order.order_items.where(order_itemable_type: "ForeignWorker").where.not(order_itemable_id: worker_ids).where(fee_id: fee_insurance_gross_premium.id).destroy_all
        order.insurance_purchases.where.not(order_item_id: order_item_ids).destroy_all

        # sst
        fee_insurance_sst = Fee.find_by(code: "INSURANCE_SST")
        # if data["TOTAL_SST"] > 0
            oi = order.order_items.where({
                order_itemable: order.customerable,
                fee_id: fee_insurance_sst.id,
            }).first_or_create
            oi.update({
                amount: (data["TOTAL_SST"] || 0).to_s.remove(',').to_f,
            })
        # else
        #     order.order_items.where(fee_id: fee_insurance_sst.id).destroy_all
        # end

        # stamp duty
        fee_insurance_stamp_duty = Fee.find_by(code: "INSURANCE_STAMP_DUTY")
        # if data["TOTAL_STAMP_DUTY"] > 0
            oi = order.order_items.where({
                order_itemable: order.customerable,
                fee_id: fee_insurance_stamp_duty.id,
            }).first_or_create
            oi.update({
                amount: (data["TOTAL_STAMP_DUTY"] || 0).to_s.remove(',').to_f,
            })
        # else
        #     order.order_items.where(fee_id: fee_insurance_stamp_duty.id).destroy_all
        # end

        # admin fees
        fee_insurance_adminfees = Fee.find_by(code: "INSURANCE_ADMINFEES")
        # if data["TOTAL_ADMINFEES"] > 0
            oi = order.order_items.where({
                order_itemable: order.customerable,
                fee_id: fee_insurance_adminfees.id,
            }).first_or_create
            oi.update({
                amount: (data["TOTAL_ADMINFEES"] || 0).to_s.remove(',').to_f,
            })
        # else
        #     order.order_items.where(fee_id: fee_insurance_adminfees.id).destroy_all
        # end

        # admin fees sst
        fee_insurance_adminfees_sst = Fee.find_by(code: "INSURANCE_ADMINFEES_SST")
        # if data["TOTAL_ADMINFEES_SST"] > 0
            oi = order.order_items.where({
                order_itemable: order.customerable,
                fee_id: fee_insurance_adminfees_sst.id,
            }).first_or_create
            oi.update({
                amount: (data["TOTAL_ADMINFEES_SST"] || 0).to_s.remove(',').to_f,
            })
        # else
        #     order.order_items.where(fee_id: fee_insurance_adminfees_sst.id).destroy_all
        # end

        order_clear_insurance(order: order)
    end
    # /save_calculated_premium

    # return data to be submitted to confirm insurance purchase
    def self.paid_premium_submit_data(order: nil, response_url: nil, backend_url: nil)
        if order.customerable_type == 'Agency'
            employer = order.order_items.where({order_itemable_type: "ForeignWorker"}).first.order_itemable.employer
            agency_ret = {
                AGENT_CODE: order.customerable.code || "",
                AGENT_NAME: order.customerable.name || "",
                AGENT_EMAIL: order.customerable.email || "",
                AGENT_ADDRESS1: order.customerable.address1 || "",
                AGENT_ADDRESS2: order.customerable.address2 || "",
                AGENT_ADDRESS3: order.customerable.address3 || "",
                AGENT_ADDRESS4: order.customerable.address4 || "",
                AGENT_POSTCODE: order.customerable.postcode || "",
                AGENT_STATECODE: order.customerable.state&.code || "",
                AGENT_COUNTRYCODE: order.customerable.country&.code || "",
                AGENT_PHONE: order.customerable.phone || "",
            }
        else
            employer = order.customerable
            agency_ret = {}
        end

        ret = {
            ORDER_CODE: order.code,
            EMPLOYER_CODE: employer.code || "",
            EMPLOYER_NAME: employer.name || "",
            EMPLOYER_TYPE: employer.employer_type_id || "",
            EMPLOYER_EMAIL: employer.email || "",
            EMPLOYER_ADDRESS1: employer.address1 || "",
            EMPLOYER_ADDRESS2: employer.address2 || "",
            EMPLOYER_ADDRESS3: employer.address3 || "",
            EMPLOYER_ADDRESS4: employer.address4 || "",
            EMPLOYER_STATECODE: employer.state&.code || "",
            EMPLOYER_POSTCODE: employer.postcode || "",
            EMPLOYER_COUNTRYCODE: employer.country&.code || "",
            EMPLOYER_TELEPHONE: employer.phone || "",
            EMPLOYER_FAX: employer.fax || "",
            EMPLOYER_ROC_NO: employer.business_registration_number || "",
            EMPLOYER_IC_PASSPORT_NO: employer.ic_passport_number || "",
            CONTACT_PERSON: employer.pic_name || "",
            WORKER_LIST: [],
            RESPONSE_URL: response_url,
            BACKEND_URL: backend_url,
        }

        ret = ret.merge(agency_ret)

        order.order_items.joins("join foreign_workers fw on order_items.order_itemable_id = fw.id and order_items.order_itemable_type = 'ForeignWorker'
        join fees f on order_items.fee_id = f.id and f.code = 'INSURANCE_GROSS_PREMIUM'
        join countries c on fw.country_id = c.id
        join job_types jt on fw.job_type_id = jt.id
        join insurance_purchases ip on order_items.id = ip.order_item_id")
        .select("order_items.id order_item_id, order_items.amount order_item_amount,
        fw.id worker_id, fw.name worker_name, fw.passport_number passport_no, fw.gender, fw.date_of_birth, fw.arrival_date, fw.pati,
        c.code country_code, jt.name job_type, ip.product_purchased, ip.insurance_provider")
        .each do |row|
            ret[:WORKER_LIST] << {
                ORDER_ITEM_ID: row.order_item_id,
                WORKER_ID: row.worker_id,
                WORKER_NAME: row.worker_name || "",
                GENDER: row.gender || "",
                DATE_OF_BIRTH: row.date_of_birth.strftime("%d/%m/%Y") || "",
                PASSPORT_NO: row.passport_no || "",
                COUNTRY_CODE: row.country_code || "",
                JOB_TYPE: row.job_type || "",
                ARRIVAL_DATE: row.arrival_date&.strftime("%d/%m/%Y") || "",
                ISPATI: row.pati ? 'Y' : 'N' || "",
                INSURER: row.insurance_provider || "",
                INS_PRODUCT: row.product_purchased || "",
            }
        end

        return ret
    end
    # /paid_premium_submit_data

    def self.save_policy(data: nil)
        data = JSON.parse(data)

        # ip_ipi_ids = {}
        data.each do |worker|
            order = Order.find_by(code: worker["ORDER_CODE"] || data["ORDER_CODE"])
            # raise ActionController::RoutingError.new('Order Not Found') if !order
            next if !order

            ip = InsurancePurchase.where({
                foreign_worker_id: worker["WORKER_ID"],
                order_id: order.id,
            }).first_or_create
            # ip_ipi_ids[ip.id] = [] if !ip_ipi_ids[ip.id]

            ipi = ip.insurance_purchase_items.where(product_name: worker["INS_PRODUCT"]).first_or_create
            ipi.update({
                product_name: worker["INS_PRODUCT"],
                start_date: worker["POLICY_START_DATE"],
                end_date: worker["POLICY_END_DATE"],
                policy_status: worker["STATUS"],
            })
            # ip_ipi_ids[ip.id] << ipi.id

            fw = ip.foreign_worker
            fw.latest_insurance_purchase_id = ip.id
            fw.save(validate: false)
        end
        # ip_ipi_ids.each do |ip_id, ipi_ids|
        #     InsurancePurchaseItem.where(insurance_purchase_id: ip_id).where.not(id: ipi_ids).destroy_all
        # end
    end

    def self.get_insurance_orders(data: nil)
        data = JSON.parse(data)
        ins_orders = []

        data.each do |worker|
            order = Order.find_by(code: worker["ORDER_CODE"] || data["ORDER_CODE"])
            has_insurance = order_has_insurance?(order: order)

            ins_order = {
                ORDER_CODE: order.code,
                ORDER_STATUS: has_insurance ? order.status : 'NO_INSURANCE_PURCHASED',
                ORDER_CREATED_DATE: has_insurance ? order.created_at.strftime("%d/%m/%Y") : '',
                ORDER_UPDATED_DATE: has_insurance ? order.updated_at.strftime("%d/%m/%Y") : '',
                ORDER_AMOUNT: has_insurance ? order.amount : '',
                EMPLOYER_NAME: has_insurance ? order.customerable.name : '',
                EMPLOYER_CONTACT_PERSON: has_insurance ? order.customerable.pic_name || '' : ''
            }

            ins_orders << ins_order
        end

        return ins_orders
    end

    def self.generate_worker_code(order: nil)
        ForeignWorker.joins("join order_items on foreign_workers.id = order_items.order_itemable_id and order_items.order_itemable_type = 'ForeignWorker'
        join insurance_purchases on foreign_workers.id = insurance_purchases.foreign_worker_id
        join fees on order_items.fee_id = fees.id and fees.code = 'INSURANCE_GROSS_PREMIUM'")
        .select("foreign_workers.*, insurance_purchases.id insurance_purchase_id, insurance_purchases.fw_code")
        .where("order_items.order_id = ?", order.id).where("insurance_purchases.fw_code" => ["", nil]).each do |fw|
            fw.update_code if fw.code.blank?
            if fw.fw_code.blank?
                InsurancePurchase.find(fw.insurance_purchase_id).update(fw_code: fw.code)
            end
        end
    end

    def self.api_1_url(provider_code: nil)
        case provider_code
        when "HOWDEN"
            "#{ENV["HOWDEN_DOMAIN"]}/PremiumCalculation/calculator.php"
        when "PROTECTMIGRANT"
            "#{ENV["PROTECTMIGRANT_DOMAIN"]}/wp-json/fomema/v1/employer"
        end
    end

    def self.api_1_url_nios(provider_code: nil)
        case provider_code
        when "HOWDEN"
            "#{ENV["HOWDEN_DOMAIN"]}/PremiumCalculation/calculatorworker.php"
        when "PROTECTMIGRANT"
            "#{ENV["PROTECTMIGRANT_DOMAIN"]}/wp-json/fomema/v1/employer"
        end
    end

    def self.api_3_url(provider_code: nil)
        case provider_code
        when "HOWDEN"
            "#{ENV["HOWDEN_DOMAIN"]}/BLL/onlinetransaction.php"
            # "#{ENV["HOWDEN_DOMAIN"]}/PremiumCalculation/worker.php"
        when "PROTECTMIGRANT"
            "#{ENV["PROTECTMIGRANT_DOMAIN"]}/wp-json/fomema/v2/payment"
        end

    end

    def self.api_3_url_nios(provider_code: nil)
        case provider_code
        when "HOWDEN"
            "#{ENV["HOWDEN_DOMAIN"]}/BLL/onlinetransactionWorker.php"
        when "PROTECTMIGRANT"
            "#{ENV["PROTECTMIGRANT_DOMAIN"]}/wp-json/fomema/v2/payment"
        end

    end

    def self.receipt_link(order_code)
        order = Order.find_by(code: order_code)
        provider_code = order.insurance_purchases.first&.insurance_service_provider&.code || "HOWDEN"

        case provider_code
        when "HOWDEN"
            "#{ENV["HOWDEN_DOMAIN"]}/PremiumCalculation/generate_receipt.php?batchId=#{order_code}"
        when "PROTECTMIGRANT"
            "#"
        end

    end

    def self.cancellation_policy_link(provider_code: nil)
        case provider_code
        when "HOWDEN"
            "#{ENV["HOWDEN_DOMAIN"]}/PremiumCalculation/storage/Refund_and_Cancellation_Policy.pdf"
        when "PROTECTMIGRANT"
            "#{ENV["PROTECTMIGRANT_DOMAIN"]}/cancellation-refund/"
        end
    end

    def self.encrypt(data, provider_code)
        cipher = OpenSSL::Cipher.new("AES-256-ECB")
        cipher.encrypt

        provider_code = provider_code || "HOWDEN"
        case provider_code
        when "HOWDEN"
            # key = cipher.random_key
            key = "#{ENV["HOWDEN_KEY"]}"
        when "PROTECTMIGRANT"
            key = "#{ENV["PROTECTMIGRANT_KEY"]}"
        end

        cipher.key = key

        # iv = cipher.random_iv
        iv = ""
        cipher.iv = iv

        encrypted = cipher.update(data) + cipher.final
        encrypted_base64 = Base64.strict_encode64(encrypted)
    end

    def self.decrypt(data, provider_code)
        decipher = OpenSSL::Cipher.new("AES-256-ECB")
        decipher.decrypt

        case provider_code
        when "HOWDEN"
            # key = cipher.random_key
            key = "#{ENV["HOWDEN_KEY"]}"
        when "PROTECTMIGRANT"
            key = "#{ENV["PROTECTMIGRANT_KEY"]}"
        end

        decipher.key = key

        # iv = cipher.random_iv
        iv = ""
        decipher.iv = iv

        plain = decipher.update(Base64.strict_decode64(data)) + decipher.final
    end

end
