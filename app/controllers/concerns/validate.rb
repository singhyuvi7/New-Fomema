module Validate
    # finance api
    class APInvoiceBatches
        include ActiveModel::Validations

        attr_accessor :batch_id, :list

        validate :array_format
        validate :batch_id_exist
        validate :sp_code_exist

        validates :batch_id, presence: true
        validates :list, presence: true

        def initialize(params={})
            @batch_id = params[:batch_id]
            @list = params[:list]
            # ActionController::Parameters.new(params.as_json).permit(:type, :batch_id, :list)
        end

        def array_format
           errors.add(:list, "not in array format") unless list.kind_of?(Array)
        end

        def batch_id_exist
            errors.add(:batch_id, "id does not exist") if ApInvoiceBatch.find_by_batch_number(self.batch_id).blank?
        end

        def sp_code_exist
            vendor_codes = SystemConfiguration.where(:code => ['HOWDEN_CODE','FGSB_CODE','TFSB_CODE']).pluck(:value)

            sp_types = ['Employer','Doctor','XrayFacility','Laboratory','ServiceProviderGroup','Agency']
            service_provider = nil
            self.list.try(:each) do |data|
                code = data['code']

                if !vendor_codes.include?(code)
                    sp_types.each do |sp_type|
                        service_provider = sp_type.constantize.model_name.singular.classify.constantize.where(:code => code).first
                        break if service_provider.present?
                    end
                else
                    break
                end

                errors.add(:list, "Code '#{code}' is invalid") if service_provider.nil?
            end
        end
    end

end