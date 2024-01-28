# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
# resources standard method: index, new, create, show, edit, update, destroy

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
    # For nios subdomains.
    constraints :subdomain => ENV["SUBDOMAIN_NIOS"].downcase do
        Sidekiq::Web.use Rack::Auth::Basic do |username, password|
            md5_of_password = Digest::MD5.hexdigest(password)
            username == ENV["SIDEKIQ_USERNAME"] && md5_of_password == ENV['SIDEKIQ_PASSWORD']
        end if !Rails.env.development?
        mount Sidekiq::Web, at: "/sidekiq"

        # logs viewer
        # mount Logster::Web => "/logs"

        # internal module
        scope module: "internal", as: "internal" do
            devise_for :users, as: 'internal', controllers: {
                sessions: 'internal/users/sessions',
                passwords: 'internal/users/passwords',
                confirmations: 'internal/users/confirmations'
                # registrations: 'internal/users/registrations',
            }

            get 'test-sleep/:sleep', to: 'home#test_sleep'
            get 'show-env', to: 'home#show_env'
            get 'ip', to: 'home#ip', as: 'nios_ip'

            resources :countries do
                resources :audits, only: [:index, :show]
            end

            resources :states do
                member do
                    get :postcodes
                    get :towns
                    get :multistatetowns
                end
                resources :audits, only: [:index, :show]
            end

            resources :towns do
                member do
                    get :clinics
                    get :radiologists
                end
                resources :audits, only: [:index, :show]
            end

            # scope "system-configurations", as: 'system_configurations' do
            #     get "", to: 'system_configurations#index'
            #     get "edit", to: 'system_configurations#edit'
            #     put "edit", to: 'system_configurations#update'
            #     get "approval", to: 'system_configurations#approval'
            #     put "approval", to: 'system_configurations#approval_update'
            # end

            resources :system_configurations, only: [:index] do
                collection do
                    get 'system'
                    get 'system_edit'
                    patch 'system_edit', to: 'system_configurations#system_update'
                    get 'system_approval'
                    patch 'system_approval', to: 'system_configurations#system_approval_update'

                    get 'xqcc'
                    get 'xqcc_edit'
                    patch 'xqcc_edit', to: 'system_configurations#xqcc_update'
                    get 'xqcc_approval'
                    patch 'xqcc_approval', to: 'system_configurations#xqcc_approval_update'

                    get 'finance'
                    get 'finance_edit'
                    patch 'finance_edit', to: 'system_configurations#finance_update'
                end

                resources :audits, only: [:index, :show]
            end

            resources :zones do
                resources :audits, only: [:index, :show]
            end

            resources :banks do
                resources :audits, only: [:index, :show]
            end

            resources :fees do
                resources :audits, only: [:index, :show]
            end

            resources :associations do
                resources :audits, only: [:index, :show]
            end

            resources :payment_methods do
                resources :audits, only: [:index, :show]
            end

            resources :change_sp_reasons do
                resources :audits, only: [:index, :show]
            end

            resources :retake_reasons do
                resources :audits, only: [:index, :show]
            end

            resources :block_reasons do
                resources :audits, only: [:index, :show]
            end

            resources :bypass_fingerprint_reasons do
                resources :audits, only: [:index, :show]
            end

            resources :monitor_reasons do
                resources :audits, only: [:index, :show]
            end

            resources :amendment_reasons do
                resources :audits, only: [:index, :show]
            end

            resources :roles
            resources :user_groups
            resources :user_setups do
                collection do
                    get "load_userable_ids/:type", to: "user_setups#load_userable_ids"
                    post 'bulk_action', to: 'user_setups#bulk_action', as: 'bulk_action'
                end
                member do
                    get 'resend-confirmation', to: 'user_setups#resend_confirmation'
                end
                resources :audits, only: [:index, :show]
            end

            # append single get route before organizations/:id catch
            get 'organizations/chart', to: 'organizations#chart'
            get 'organizations/tree', to: 'organizations#tree'
            resources :organizations do
                resources :audits, only: [:index, :show]
            end

            resources :template_variables do
                resources :audits, only: [:index, :show]
            end

            resources :job_types do
                resources :audits, only: [:index, :show]
            end

            resources :laboratory_types do
                resources :audits, only: [:index, :show]
            end

            resources :call_log_case_types do
                resources :audits, only: [:index, :show]
            end

            resources :titles do
                resources :audits, only: [:index, :show]
            end

            resources :fp_devices

            resources :district_health_offices do
                resources :audits, only: [:index, :show]
            end

            resources :employer_types do
                resources :audits, only: [:index, :show]
            end

            resources :appeal_todos do
                resources :audits, only: [:index, :show]
            end

            resources :tcupi_todos do
                resources :audits, only: [:index, :show]
            end

            resources :digital_xray_providers do
                resources :audits, only: [:index, :show]
            end

            resources :insurance_service_providers do
                resources :audits, only: [:index, :show]
            end

            resources :finance_settings do
                resources :audits, only: [:index, :show]
            end

            resources :races do
                resources :audits, only: [:index, :show]
            end

            resources :approval_approvers do
                resources :audits, only: [:index, :show]
            end

            get 'approval_approvers/:category/category_approvers', to: '/internal/approval_approvers#category_approvers', as: "category_approvers"

            resources :bulletins
            resources :clinics
            resources :xray_dispatches
            resources :xray_storages
            resources :activities, only: [:index]

            resources :call_logs do
                collection do
                    get "search_callable"
                end
                resources :call_log_follow_ups
            end

            resources :bank_drafts do
                member do
                    get 'hold'
                    post 'hold', to: 'bank_drafts#hold_update'
                    get 'unhold'
                    patch 'unhold', to: 'bank_drafts#unhold_update'

                    get 'bad'
                    get 'unbad'

                    get 'replace'
                    patch 'replace', to: 'bank_drafts#replace_update'

                    get 'refund'
                    patch 'refund', to: 'bank_drafts#refund_update'
                end

                resources :bd_refunds
            end

            resources :orders do
                member do
                    get 'approval'
                    patch 'approval', to: 'orders#approval_update'

                    get 'payment'
                    patch 'payment', to: 'orders#payment_update'

                    get 'payment/bankdraft', to: 'orders#payment_bankdraft'
                    get 'payment/bankdraft/new', to: 'orders#payment_bankdraft_new'
                    put 'payment/bankdraft', to: 'orders#payment_bankdraft_create'
                    get 'payment/bankdraft/:bank_draft_id/edit', to: 'orders#payment_bankdraft_edit', as: "payment_bankdraft_edit"
                    patch 'payment/bankdraft/:bank_draft_id', to: 'orders#payment_bankdraft_update', as: "payment_bankdraft_update"
                    delete 'payment/bankdraft/:bank_draft_id', to: 'orders#payment_bankdraft_destroy', as: "payment_bankdraft_destroy"
                    get 'payment/bankdraft/:bank_draft_id/add', to: 'orders#payment_bankdraft_add', as: "payment_bankdraft_add"
                    put 'payment/bankdraft/:bank_draft_id/add', to: 'orders#payment_bankdraft_add_update'

                    post 'payment_status'
                    post 'payment_status_backend'

                    post 'change_comment', to: 'orders#change_comment', as: 'change_comment'
                    post 'change_fee', to: 'orders#change_fee', as: 'change_fee'
                    post 'add_fw', to: 'orders#add_fw', as: 'add_fw'
                    get 'remove_fw', to: 'orders#remove_fw', as: 'remove_fw'
                    patch 'update_fw', to: 'orders#update_fw', as: 'update_fw'

                    get "remove-order-item/:oi_id", to: "orders#remove_order_item", as: "remove_order_item"

                    get 'invoice', to: 'orders#invoice', as: 'invoice'

                    get 'requery', to: 'orders#requery', as: 'requery'
                    get 'requery/fpx_request', to: 'orders#requery_fpx_request', as: 'requery_fpx_request'
                    get 'payment/fpxrequest/:fpx_request_id', to: 'orders#requery_fpx_request_ae', as: 'requery_fpx_request_ae'
                    get 'edit_status', to: 'orders#edit_status', as: 'edit_status'
                    patch 'edit_status_update', to: 'orders#edit_status_update', as: 'edit_status_update'
                    get 'requery/boleh_request', to: 'orders#requery_boleh_request', as: 'requery_boleh_request'
                    get 'payment/bolehrequest/:boleh_request_id', to: 'orders#requery_boleh_request_ae', as: 'requery_boleh_request_ae'
                end
                resources :audits, only: [:index, :show]
            end

            resources :refunds do
                member do
                    get 'draft'
                    get 'approval'
                    patch 'approval', to: 'refunds#approval_update'
                    get 'cancel'
                    get 'status'
                    patch 'status', to: 'refunds#status_update'
                    get 'credit_note'
                    post 'reprocess', to: 'refunds#reprocess', as: 'reprocess'
                end

                collection do
                    post 'bulk', to: 'refunds#bulk'

                    get 'export', to: 'refunds#export', as: 'export'
                end

                resources :audits, only: [:index, :show]
            end

            ## refund batches
            resources :refund_batches do
                member do
                    get 'process', to: 'refund_batches#process_payment', as: 'process'
                    get 'download', to: 'refund_batches#download', as: 'download'
                end
            end

            resources :drafts, only: [:index, :show] do
                get :submit_for_approval
            end

            # service provider payments
            scope 'payments', as: 'payments' do
                get '/', to: 'service_provider_payments#index'
                get ':id/batches', to: 'service_provider_payments#show', as: 'batch_show'
                get 'new', to: 'service_provider_payments#new', as: 'batch_new'

                get 'get_batches', to:'service_provider_payments#get_batches'

                get 'bulk_update_template', to: 'service_provider_payments#bulk_update_template', as: 'bulk_update_template'
                post 'generate_batch', to:'service_provider_payments#create', as: 'batch_create'
                post 'bulk_update/:id', to:'service_provider_payments#bulk_update', as: 'bulk_update'
                get 'reprocess/:id', to: 'service_provider_payments#reprocess', as: 'reprocess'
                get 'process/:id', to: 'service_provider_payments#process_payment', as: 'process'

                # export data
                get ':id/export', to: 'service_provider_payments#export', as: 'export'
            end
            #end

            scope 'manual_payment', as: 'manual_payment' do
                get "/", to: "service_provider_payments#view_transactions", as: "view_transactions"
                get ":id/edit_payment_xray", to: "service_provider_payments#edit_payment_xray", as: "edit_payment_xray"
                post ":id/update_payment", to: "service_provider_payments#update_payment", as: "update_payment"
                get ":id/edit_payment_lab", to: "service_provider_payments#edit_payment_lab", as: "edit_payment_lab"
                get ":id/view_payment_xray", to: "service_provider_payments#view_payment_xray", as: "view_payment_xray"
                get ":id/view_payment_lab", to: "service_provider_payments#view_payment_lab", as: "view_payment_lab"

                get ":id/view_payment_doctor", to: "service_provider_payments#view_payment_doctor", as: "view_payment_doctor"
                get ":id/edit_payment_doctor", to: "service_provider_payments#edit_payment_doctor", as: "edit_payment_doctor"

                get "/export",to: "service_provider_payments#export_manual_payment", as: "export_manual_payment"
            end

            scope 'payment_listing', as: 'payment_listing' do
                get "/", to: "service_provider_payments#view_payment_listing", as: "view_payment_listing"
                get '/export', to: 'service_provider_payments#export_payment_listing', as: 'export_payment_listing'
            end

            resources :insurance_payments do
                member do
                    post 'process', to: 'insurance_payments#process_payment', as: 'process'
                    get 'export', to: 'insurance_payments#export', as: 'export'
                end
            end

            resources :agencies do
                collection do
                    get ':id/approval', to: 'agencies#approval', as: 'approval'

                    put ':id/approve', to: 'agencies#approve', as: 'approve'
                    put ':id/approve_new_record', to: 'agencies#approve_new_record', as: 'approve_new_record'
                    put ':id/reject_new_record', to: 'agencies#reject_new_record', as: 'reject_new_record'
                    put ':id/reject', to: 'agencies#reject', as: 'reject'
                    patch ':id/cancel', to: 'agencies#cancel', as: 'cancel'
                end

                member do
                    get 'registration_approval'
                    patch 'registration_approval', to: 'agencies#registration_approval_update'

                end

                resources :audits, only: [:index, :show]
            end

            resources :employers do
                # delete :remove_document_at_index, on: :member
                collection do
                    get ':id/approval', to: 'employers#approval', as: 'approval'

                    put ':id/approve', to: 'employers#approve', as: 'approve'
                    put ':id/approve_new_record', to: 'employers#approve_new_record', as: 'approve_new_record'
                    put ':id/reject_new_record', to: 'employers#reject_new_record', as: 'reject_new_record'
                    put ':id/reject', to: 'employers#reject', as: 'reject'
                    patch ':id/cancel', to: 'employers#cancel', as: 'cancel'

                    get 'bulk_upload_foreign_worker_template', to: 'employers#bulk_upload_foreign_worker_template', as: 'bulk_upload_foreign_worker_template'
                    post ':id/bulk_upload_foreign_worker', to: 'employers#bulk_upload_foreign_worker', as: 'bulk_upload_foreign_worker'

                    get ':id/show_ori', to: 'employers#show_ori', as: 'show_ori'

                    get 'export', to: 'employers#export', as: 'export'
                end
                # /collection

                member do
                    # employer registration approval
                    get 'registration_approval'
                    patch 'registration_approval', to: 'employers#registration_approval_update'

                    get 'amendment_approval'
                    patch 'amendment_approval', to: 'employers#amendment_approval_update'

                    get 'move_fw'
                    patch 'move_fw', to: 'employers#move_fw_update'

                    get 'resend_confirmation', to: 'employers#resend_confirmation'
                end

                resources :audits, only: [:index, :show]

                resources :employer_workers do
                    collection do
                        get ':id/approval', to: 'employer_workers#approval', as: 'approval'
                        patch ':id/approval', to: 'employer_workers#approval_update', as: 'approval_update'
                        put ':id/approve', to: 'employer_workers#approve', as: 'approve'
                        put ':id/approve_new_record', to: 'employer_workers#approve_new_record', as: 'approve_new_record'
                        put ':id/reject_new_record', to: 'employer_workers#reject_new_record', as: 'reject_new_record'
                        put ':id/reject', to: 'employer_workers#reject', as: 'reject'
                        patch ':id/cancel', to: 'employer_workers#cancel', as: 'cancel'

                        get 'bulk_upload', to: 'employer_workers#bulk_upload', as: 'bulk_upload'
                        post 'bulk_upload', to: 'employer_workers#bulk_upload_store'
                        post 'bulk_upload_preview', to: 'employer_workers#bulk_upload_preview'

                        get 'bulk_upload_template', to: 'employer_workers#bulk_upload_template', as: 'bulk_upload_template'
                        get 'bulk_upload_specification', to: 'employer_workers#bulk_upload_specification', as: 'bulk_upload_specification'

                        post 'bulk_action', to: 'employer_workers#bulk_action', as: 'bulk_action'

                        patch ':id/change_gender', to: 'employer_workers#change_gender', as: 'change_gender'

                        get 'bulk_transfer_worker', to: 'employer_workers#bulk_transfer_worker'
                        post 'bulk_transfer_worker', to: 'employer_workers#bulk_transfer_worker_update'

                        get ':id/approval_change_employer', to: 'employer_workers#approval_change_employer', as: 'approval_change_employer'
                        patch ':id/approval_change_employer', to: 'employer_workers#approval_change_employer_update', as: 'approval_change_employer_update'
                    end
                    member do
                        get 'reverted'
                        patch 'reverted', to: 'employer_workers#reverted_update'
                        get 'block'
                        patch 'block', to: 'employer_workers#block_update'
                        get 'unblock'
                        patch 'unblock', to: 'employer_workers#unblock_update'
                        get 'monitor'
                        patch 'monitor', to: 'employer_workers#monitor_update'
                        get 'unmonitor'
                        patch 'unmonitor', to: 'employer_workers#unmonitor_update'
                        get 'employer'
                        patch 'employer', to: 'employer_workers#employer_update'
                        get :activate
                        patch :activate, to: 'employer_workers#activate_update'
                        get :deactivate
                        patch :deactivate, to: 'employer_workers#deactivate_update'
                        get 'upload'
                        patch 'upload', to: 'employer_workers#upload'
                        get 'show_amendment_history', to: 'employer_workers#show_amendment_history', as: 'show_amendment_history'
                    end
                    resources :audits, only: [:index, :show]
                end
                # /employer_workers

                resources :employer_users do
                    collection do
                        get :bulk_supplement
                        put :bulk_supplement, to: 'employer_users#bulk_supplement_create'
                        get :bulk_supplement_template
                    end
                end

                resources :employer_documents
            end
            # /employers

            resources :foreign_workers do
                collection do
                    get ':id/approval', to: 'foreign_workers#approval', as: 'approval'
                    put ':id/approve', to: 'foreign_workers#approve', as: 'approve'
                    put ':id/approve_new_record', to: 'foreign_workers#approve_new_record', as: 'approve_new_record'
                    put ':id/reject_new_record', to: 'foreign_workers#reject_new_record', as: 'reject_new_record'
                    put ':id/reject', to: 'foreign_workers#reject', as: 'reject'
                    patch ':id/cancel', to: 'foreign_workers#cancel', as: 'cancel'
                    get ':id/block', to: 'foreign_workers#block', as: 'block'
                    patch ':id/block', to: 'foreign_workers#block_update'
                    get ':id/unblock', to: 'foreign_workers#unblock', as: 'unblock'
                    patch ':id/unblock', to: 'foreign_workers#unblock_update'

                    post 'bulk_action', to: 'foreign_workers#bulk_action', as: 'bulk_action'
                end
            end

            resources :fw_change_employers do
                collection do
                end

                member do
                end
            end

            resources :fw_documents_history do
                collection do
                end

                member do
                end
            end

            resources :doctors do
                collection do
                    get ':id/approval', to: 'doctors#approval', as: 'approval'
                    patch ':id/approval', to: 'doctors#approval_update', as: 'approval_update'
                    get ':id/concur', to: 'doctors#concur', as: 'concur'
                    patch ':id/concur', to: 'doctors#concur_update', as: 'concur_update'
                    patch ':id/activate', to: 'doctors#activate', as: 'activate'
                    get ':id/cancel', to: 'doctors#cancel', as: 'cancel'
                    post "filter_xray_facilities", "filter_laboratories", "assign_quota"
                    get ':id/operation_hours', to: "doctors#operation_hours", as: 'operation_hours'
                    get "wall_list", to: "doctors#wall_list", as: "wall_list"
                end

                member do
                    get :draft, :registration_invoice, :pairing_letter, :approval_letter, :allocation_letter, :temporary_allocation_letter, :reallocation_back_letter, :change_address_approval, :registration_letter, :allocated_workers, :suspension_history, :coupling_history, :summary_loading_statistic, :buy_biometric_device
                end

                resources :audits, only: [:index, :show]
            end

            resources :laboratories do
                collection do
                    get ':id/approval', to: 'laboratories#approval', as: 'approval'
                    patch ':id/approval', to: 'laboratories#approval_update', as: 'approval_update'
                    get ':id/concur', to: 'laboratories#concur', as: 'concur'
                    patch ':id/concur', to: 'laboratories#concur_update', as: 'concur_update'
                    patch ':id/activate', to: 'laboratories#activate', as: 'activate'
                    get ':id/cancel', to: 'laboratories#cancel', as: 'cancel'
                    get ':id/bulk_reallocate', to: 'laboratories#bulk_reallocate', as: 'bulk_reallocate'
                    put ':id/bulk_reallocate', to: 'laboratories#bulk_reallocate_update', as: 'bulk_reallocate_update'
                    get 'search_laboratory', to: 'laboratories#search_laboratory', as: 'search_laboratory'

                    get ':id/operation_hours', to: "laboratories#operation_hours", as: 'operation_hours'
                end
                member do
                    get :draft, :registration_invoice, :approval_letter, :change_address_approval, :registration_letter, :allocated_workers, :suspension_history, :summary_loading_statistic
                end
                resources :audits, only: [:index, :show]
            end

            resources :xray_facilities do
                collection do
                    get ':id/approval', to: 'xray_facilities#approval', as: 'approval'
                    patch ':id/approval', to: 'xray_facilities#approval_update', as: 'approval_update'
                    get ':id/concur', to: 'xray_facilities#concur', as: 'concur'
                    patch ':id/concur', to: 'xray_facilities#concur_update', as: 'concur_update'
                    patch ':id/activate', to: 'xray_facilities#activate', as: 'activate'
                    get ':id/cancel', to: 'xray_facilities#cancel', as: 'cancel'
                    get ':id/bulk_reallocate', to: 'xray_facilities#bulk_reallocate', as: 'bulk_reallocate'
                    put ':id/bulk_reallocate', to: 'xray_facilities#bulk_reallocate_update', as: 'bulk_reallocate_update'
                    get 'search_xray_facility', to: 'xray_facilities#search_xray_facility', as: 'search_xray_facility'

                    get ':id/operation_hours', to: "xray_facilities#operation_hours", as: 'operation_hours'
                    get ':id/license_expiry_amendment_logs', to: 'xray_facilities#license_expiry_amendment_logs', as: 'license_expiry_amendment_logs'
                end
                member do
                    get :draft, :registration_invoice, :approval_letter, :change_address_approval, :registration_letter, :allocated_workers, :suspension_history, :summary_loading_statistic, :buy_biometric_device
                end
                resources :favourite_radiologists
                resources :audits, only: [:index, :show]
            end

            resources :radiologists do
                collection do
                    get ':id/approval', to: 'radiologists#approval', as: 'approval'
                    patch ':id/approval', to: 'radiologists#approval_update', as: 'approval_update'
                    get ':id/concur', to: 'radiologists#concur', as: 'concur'
                    patch ':id/concur', to: 'radiologists#concur_update', as: 'concur_update'
                    patch ':id/activate', to: 'radiologists#activate', as: 'activate'
                    get ':id/cancel', to: 'radiologists#cancel', as: 'cancel'
                    post "xray_facilities_filter"
                end
                member do
                    get 'draft'
                    patch 'draft', to: 'radiologists#draft_update'
                    get :reject_renew, :registration_invoice, :approval_letter, :registration_letter, :change_address_approval, :summary_loading_statistic
                end
                resources :audits, only: [:index, :show]
            end

            resources :service_provider_groups do
                member do
                    get "members"
                    get "members/new", to: 'service_provider_groups#member_new'
                    post "members", to: 'service_provider_groups#member_create'
                    delete "members/:member_id", to: 'service_provider_groups#member_destroy', as: "member_destroy"
                end

                resources :audits, only: [:index, :show]
            end

            resources :status_schedules do
                collection do
                    get "scheduleable_statuses/:type", to: "status_schedules#scheduleable_statuses", as: "scheduleable_statuses"
                    get "scheduleable_status_reasons/:type/:status", to: "status_schedules#scheduleable_status_reasons", as: "scheduleable_status_reasons"
                end
                resources :audits, only: [:index, :show]
            end

            resources :group_schedules do
                collection do
                    get "service_provider_groups/:type", to: "group_schedules#schedulable_groups", as: "schedulable_groups"
                end
            end

            resources :password_policies do
                collection do
                    put 'revision/:id/approve', to: 'password_policies#approve', as: 'approve_revision'
                    put 'revision/:id/reject', to: 'password_policies#reject', as: 'reject_revision'
                    patch 'revision/:id/cancel', to: 'password_policies#cancel', as: 'cancel_revision'
                end
            end

            resources :transactions do
                collection do
                    get ":code/transaction_by_code", to: "transactions#transaction_by_code", as: "transaction_by_code"
                    get ":code/transaction_by_code_storage", to: "transactions#transaction_by_code_storage", as: "transaction_by_code_storage"

                    post "filter_doctors", "assign_doctors"
                    post 'bulk_coupling_update'

                    get "bulk_print_medical_form"

                    post "filter_xray_examination_comparisons", to: "xqccs#filter_xray_examination_comparisons"

                    get 'reprint_medical_form'
                    post 'reprint_medical_form', to: 'transactions#reprint_medical_form_update'

                    get 'export', to: 'transactions#export', as: 'export'
                end

                member do
                    get "medical_form_print", "unsuitable_slip", "physical_exam_not_done", "toggle_ignore_merts_expiry", "toggle_ignore_reprint_rules", "abort_radiologist", "tcupi_audit_case_letter", "tcupi_nonaudit_case_letter", "toggle_unsuitable_slip_download", "toggle_ignore_cancellation_rule", "resend_unsuitable_letter", "digital_xray_availability", "toggle_imm_block", "toggle_ignore_renewal_rule", "appeal_pdpa_form", "appeal_agency_pdpa_form"
                    get "medical_report_letter", "toggle_medical_report_letter_download", "view_approval", "toggle_ignore_special_renewal_rule", "special_renewal_authorisation_letter","examination_report"

                    post "update_result", "amend_final_status", "amendment_approval", "cancel_amendment", "revert_laboratory_status_to_exam", "revert_xray_status_to_exam", "remove_transaction_examination_date", "update_unsuitable_reasons"

                    get 'cancel', to: 'transactions#cancel', as: 'cancel'
                    patch 'cancel', to: 'transactions#cancel_update'

                    get 'extend', to: 'transactions#extend', as: 'extend'
                    patch 'extend', to: 'transactions#extend_update'

                    get "approval"
                    patch 'approval', to: 'transactions#approval_update'

                    get 'bypass_fingerprint'
                    patch 'bypass_fingerprint', to: 'transactions#bypass_fingerprint_update'

                    get 'coupling'
                    patch 'coupling', to: 'transactions#coupling_update'

                    get 'agency_document_approval'
                    patch 'agency_document_approval', to: 'transactions#agency_document_approval_update'

                    get 'bypass_fingerprint_approval'
                    patch 'bypass_fingerprint_approval_update', to: 'transactions#bypass_fingerprint_approval_update'

                    get 'sync_latest_passport_number'
                    patch 'sync_latest_passport_number', to: 'transactions#sync_latest_passport_number'
                end

                resources :audits, only: [:index, :show]

                resources :xqccs, only: [] do
                    collection do
                        post "filter_xray_examinations"
                    end
                end
            end

            # xqcc routes
            resources :transactions, param: :transaction_id do
                member do
                    get "merts_results", to: "xqccs#merts_result", as: "merts_results"
                    get "xqcc_movements", to: "xqccs#xqcc_movement", as: "xqcc_movements"
                end
            end
            # finish xqcc routes

            resources :doctor_examinations, only: [] do
                resources :audits, only: [:index, :show]
            end

            resources :laboratory_examinations, only: [] do
                resources :audits, only: [:index, :show]
            end

            resources :xray_examinations, only: [] do
                resources :audits, only: [:index, :show]
            end

            resources :xray_pending_reviews, only: [:index, :edit, :update, :show] do
                collection do
                    post :filter_compares
                end
                resources :audits, only: [:index, :show]
            end

            resources :xray_pending_decisions do
                collection do
                    get :approval, to: "xray_pending_decisions#approval_index"
                end
                member do
                    get :approval
                    patch :approval, to: "xray_pending_decisions#approval_update"
                end
                resources :audits, only: [:index, :show]
            end

            resources :xray_retakes do
                collection do
                    get :pcr, :xqcc
                end
                member do
                    get :draft, :approval
                    patch :draft, to: "xray_retakes#draft_update"
                    patch :approval, to: "xray_retakes#approval_update"
                end
                resources :xray_retake_follow_ups
                resources :audits, only: [:index, :show]
            end

            resources :pcr_pools, only: [] do
                collection do
                    get :pickup, :reassign
                    patch :pickup, to: "pcr_pools#pickup_update"
                    patch :reassign, to: "pcr_pools#reassign_update"
                end
                resources :audits, only: [:index, :show]
            end

            resources :pcr_reviews do
                resources :audits, only: [:index, :show]
            end

            resources :xqcc_pools, only: [] do
                collection do
                    get :pickup, :reassign
                    patch :pickup, to: "xqcc_pools#pickup_update"
                    patch :reassign, to: "xqcc_pools#reassign_update"
                end
                resources :audits, only: [:index, :show]
            end

            resources :xray_reviews do
                collection do
                    post :filter_identicals
                    get :bulk_physical_review
                    patch :bulk_physical_review, to: "xray_reviews#bulk_physical_review_update"
                end
                resources :audits, only: [:index, :show]
            end

            resources :medical, only: [:index, :show] do
                member do
                    get  "manage_tcupi_todos", to: "transaction_tcupi_todos#manage_todos"
                    get  "medical_review", "tcupi_review", "tcupi_review_approval","medical_pr_qa"
                    post "mle_review_1", "mle_review_2", "tcupi_review_1", "tcupi_review_2","medical_mle_qa_status"
                end
            end

            resources :appeals, only: [:index, :new, :create, :show, :update] do
                member do
                    get  "appeal_approval", "appeal_results", "appeal_employer_instruction_letter", "appeal_doctor_instruction_letter"
                    post "new_comment", "appeal_approval_decision", "cancel_appeal_approval_request", "pcr_second_third_opinion", "repeat_xray"
                end

                collection do
                    get  "document_completed_report"
                end
            end

            resources :reassign_xqcc_pcr, only: [] do
                collection do
                    get "appeal_pcr_reviews"
                end

                member do
                    get "appeal_pcr_review", "appeal_pcr_pool"
                    patch "appeal_pcr_review_update", "appeal_pcr_pool_update"
                end
            end

            resources :xqcc_letters, only: [:index] do
                [:wrong_transmission_letter, :xqcc_misread_letter, :xqcc_audit_result_letter, :xqcc_active_ptb_letter, :xqcc_audit_radiograph_letter, :xqcc_non_compliance_letter, :xqcc_identical_letter, :xqcc_fraud_case_letter, :xqcc_acknowledgement_fraud_case_letter].each do |route_name|
                    collection do
                        get "#{ route_name }_index", "#{ route_name }_new", "#{ route_name }_index", "#{ route_name }_edit"
                        post "#{ route_name }_save", "#{ route_name }_search"
                    end

                    member do
                        get "#{ route_name }"
                    end
                end

                collection do
                    post :xqcc_identical_foreign_worker_search
                end
            end

            resources :moh_notifications, only: [:index] do
                collection do
                    post "release_notification"
                end
            end

            resources :xqccs, only: [] do
                collection do
                    get "merts_result_index", to: "xqccs#merts_result_index"
                    get "movement_index", to: "xqccs#movement_index"
                end
            end

            # transaction - myimms
            scope 'myimms', as: 'myimms' do
                get '/', to: 'myimms#index'
                get '/submit', to: 'myimms#submit_to_jim'
            end
            #end

            resources :insurance_histories, only: [:index, :show] do
                member do
                    get :resubmit_paid
                end
            end

            # visit plans clinics

            get 'visit_plans/clinics/providers', to: "visit_plan_clinics#providers"
            get 'visit_plans/clinics/search_providers', to: "visit_plan_clinics#search_providers"
            get 'visit_plans/clinics/new', to: "visit_plan_clinics#new"
            get 'visit_plans/clinics/:id/edit', to: "visit_plan_clinics#edit", as: "visit_plan_clinic_edit"
            get 'visit_plans/clinics', to: "visit_plan_clinics#index"
            get 'visit_plans/clinics/:id/approval', to: 'visit_plan_clinics#approval', as: 'visit_plan_clinic_approval'
            get 'visit_plans/clinics/:id', to: "visit_plan_clinics#show", as: "visit_plan_clinic_show"

            post 'visit_plans/clinics/create', to: "visit_plan_clinics#create"
            put 'visit_plans/clinics/:id', to: "visit_plan_clinics#update", as: "visit_plan_clinic_update"
            delete 'visit_plans/clinics/:id', to: "visit_plan_clinics#destroy", as: "visit_plan_clinic_delete"
            put 'visit_plans/clinics/:id/approval', to: "visit_plan_clinics#approve_report", as: "visit_plan_clinic_approve_report"

            # visit plans xray_facilities

            get 'visit_plans/xray_facilities/providers', to: "visit_plan_xray_facilities#providers"
            get 'visit_plans/xray_facilities/search_providers', to: "visit_plan_xray_facilities#search_providers"
            get 'visit_plans/xray_facilities/new', to: "visit_plan_xray_facilities#new"
            get 'visit_plans/xray_facilities/:id/edit', to: "visit_plan_xray_facilities#edit", as: "visit_plan_xray_facility_edit"
            get 'visit_plans/xray_facilities', to: "visit_plan_xray_facilities#index"
            get 'visit_plans/xray_facilities/:id/approval', to: 'visit_plan_xray_facilities#approval', as: 'visit_plan_xray_facility_approval'
            get 'visit_plans/xray_facilities/:id', to: "visit_plan_xray_facilities#show", as: "visit_plan_xray_facility_show"

            post 'visit_plans/xray_facilities/create', to: "visit_plan_xray_facilities#create"
            put 'visit_plans/xray_facilities/:id', to: "visit_plan_xray_facilities#update", as: "visit_plan_xray_facility_update"
            delete 'visit_plans/xray_facilities/:id', to: "visit_plan_xray_facilities#destroy", as: "visit_plan_xray_facility_delete"
            put 'visit_plans/xray_facilities/:id/approval', to: "visit_plan_xray_facilities#approve_report", as: "visit_plan_xray_facility_approve_report"

            # visit plans laboratories

            get 'visit_plans/laboratories/providers', to: "visit_plan_laboratories#providers"
            get 'visit_plans/laboratories/search_providers', to: "visit_plan_laboratories#search_providers"
            get 'visit_plans/laboratories/new', to: "visit_plan_laboratories#new"
            get 'visit_plans/laboratories/:id/edit', to: "visit_plan_laboratories#edit", as: "visit_plan_laboratory_edit"
            get 'visit_plans/laboratories', to: "visit_plan_laboratories#index"
            get 'visit_plans/laboratories/:id/approval', to: 'visit_plan_laboratories#approval', as: 'visit_plan_laboratory_approval'
            get 'visit_plans/laboratories/:id', to: "visit_plan_laboratories#show", as: "visit_plan_laboratory_show"

            post 'visit_plans/laboratories/create', to: "visit_plan_laboratories#create"
            put 'visit_plans/laboratories/:id', to: "visit_plan_laboratories#update", as: "visit_plan_laboratory_update"
            delete 'visit_plans/laboratories/:id', to: "visit_plan_laboratories#destroy", as: "visit_plan_laboratory_delete"
            put 'visit_plans/laboratories/:id/approval', to: "visit_plan_laboratories#approve_report", as: "visit_plan_laboratory_approve_report"

            # visit plans
            get 'visit_plans/:id/download', to: "visit_plans#download", as: "visit_plan_download"

            resources :visit_plan_approvals

            resources :visit_plans

            # visit reports
            get 'visit_reports/:id/explanation_letter', to:'visit_reports#explanation_letter', as: "visit_report_explanation_letter"

            # visit reports clinics
            get 'visit_report_clinics/new', to: "visit_report_clinics#new"
            get 'visit_report_clinics/:id/edit', to: "visit_report_clinics#edit", as: "visit_report_clinic_edit"
            get 'visit_report_clinics', to: "visit_report_clinics#index"
            get 'visit_report_clinics/:id/approval', to: 'visit_report_clinics#approval', as: 'visit_report_clinic_approval'
            get 'visit_report_clinics/:id', to: "visit_report_clinics#show", as: "visit_report_clinic_show"
            get 'visit_report_clinics/:id/download', to: "visit_report_clinics#download", as: "visit_report_clinic_download"
            get 'visit_report_clinics/:id/submit_to_clinic', to: "visit_report_clinics#submit_to_clinic", as: "visit_report_clinic_submit_to_clinic"

            post 'visit_report_clinics', to: "visit_report_clinics#create"
            put 'visit_report_clinics/:id', to: "visit_report_clinics#update", as: "visit_report_clinic_update"
            delete 'visit_report_clinics/:id', to: "visit_report_clinics#destroy", as: "visit_report_clinic_delete"
            put 'visit_report_clinics/:id/approval', to: "visit_report_clinics#approve_report", as: "visit_report_clinic_approve_report"
            patch 'visit_report_clinics/:id/signature', to: "visit_report_clinics#update_signature", as: "visit_report_clinic_signature"

            # visit reports xray_facilities

            get 'visit_report_xray_facilities/new', to: "visit_report_xray_facilities#new"
            get 'visit_report_xray_facilities/:id/edit', to: "visit_report_xray_facilities#edit", as: "visit_report_xray_facility_edit"
            get 'visit_report_xray_facilities', to: "visit_report_xray_facilities#index"
            get 'visit_report_xray_facilities/:id/approval', to: 'visit_report_xray_facilities#approval', as: 'visit_report_xray_facility_approval'
            get 'visit_report_xray_facilities/:id', to: "visit_report_xray_facilities#show", as: "visit_report_xray_facility_show"
            get 'visit_report_xray_facilities/:id/download', to: "visit_report_xray_facilities#download", as: "visit_report_xray_facility_download"
            get 'visit_report_xray_facilities/:id/submit_to_clinic', to: "visit_report_xray_facilities#submit_to_clinic", as: "visit_report_xray_facility_submit_to_clinic"

            post 'visit_report_xray_facilities', to: "visit_report_xray_facilities#create"
            put 'visit_report_xray_facilities/:id', to: "visit_report_xray_facilities#update", as: "visit_report_xray_facility_update"
            delete 'visit_report_xray_facilities/:id', to: "visit_report_xray_facilities#destroy", as: "visit_report_xray_facility_delete"
            put 'visit_report_xray_facilities/:id/approval', to: "visit_report_xray_facilities#approve_report", as: "visit_report_xray_facility_approve_report"
            patch 'visit_report_xray_facilities/:id/signature', to: "visit_report_xray_facilities#update_signature", as: "visit_report_xray_faciliy_signature"

            # visit reports laboratories

            get 'visit_reports_laboratories/new', to: "visit_report_laboratories#new"
            get 'visit_reports_laboratories/:id/edit', to: "visit_report_laboratories#edit", as: "visit_report_laboratory_edit"
            get 'visit_reports_laboratories', to: "visit_report_laboratories#index"
            get 'visit_reports_laboratories/:id/approval', to: 'visit_report_laboratories#approval', as: 'visit_report_laboratory_approval'
            get 'visit_reports_laboratories/:id', to: "visit_report_laboratories#show", as: "visit_report_laboratory_show"

            post 'visit_reports_laboratories', to: "visit_report_laboratories#create"
            patch 'visit_reports_laboratories/:id', to: "visit_report_laboratories#update", as: "visit_report_laboratory_update"
            delete 'visit_reports_laboratories/:id', to: "visit_report_laboratories#destroy", as: "visit_report_laboratory_delete"
            patch 'visit_reports_laboratories/:id/approval', to: "visit_report_laboratories#approve_report", as: "visit_report_laboratory_approve_report"

            get 'visit_reports_laboratories/:id/visit_summary', to: "visit_report_laboratories#visit_summary", as: 'visit_report_laboratory_visit_summary'
            get 'visit_reports_laboratories/:id/submit_to_lab', to: "visit_report_laboratories#submit_to_lab", as: 'visit_report_laboratory_submit_to_lab'
            get 'visit_reports_laboratories/:id/download', to: "visit_report_laboratories#download", as: 'visit_report_laboratory_download'

            resources :lqcc_letters do
                member do
                    get 'approval','explanation_letter', 'preview_explanation_letter'
                    patch 'approval', to: 'lqcc_letters#approval_update'

                    ## warning letter
                    get 'edit_warning_letter','approval_warning_letter','warning_letter', 'preview_warning_letter'
                    patch 'update_warning_letter','update_approval_warning_letter'
                end
            end

            # end of visit reports

            # development only routes (remove when go live)
            resources :developments, only: [] do
                collection do
                    post "jim/fomema/getBiodata", to: "developments#jim_get_biodata"
                    match 'PremiumCalculation/calculator', to: "developments#howden_calculator", via: :all
                    match 'PremiumCalculation/worker', to: "developments#howden_insurance_purchase", via: :all
                end
            end
            # /development

            resources :reports, only: [:index] do
                collection do
                    get "csv_sample", "excel_sample"

                    # for testing/demo
                    get :finance_demo, :mspd_demo

                    # Report Settings
                    post "retrieve_settings", "update_settings"
                end
            end

            resources :medical_reports, only: [:index] do
                collection do
                    # Appeals Reports
                    get :type_of_diseases, :medical_appeal, :cronjob_appeal, :cronjob_reappeal, :cronjob_reject_appeal, :appeal_weekly_report

                    # Monthly Stats Reports
                    get :med_monthly_stat_appeal, :med_monthly_stat_pr, :med_monthly_stat_tcupi, :med_monthly_stat_unfit_reason, :med_monthly_stat_reuse_passport

                    # Other Medical Reports
                    get :cronjob_moh_weekly_email_report, :cronjob_moh_weekly_system_report_by_state, :email_of_repatriation_notice, :report_unfit_notice, :report_review_qa

                    # Wrong Transmission Reports
                    get :wrong_transmission_doctor, :wrong_transmission_lab, :wrong_transmission_xray
                end
            end

            resources :branch_reports, only: [:index] do
                collection do
                    # Registrations
                    get :pati_registration_statistics, :registration_by_job_sector, :registration_breakdown, :new_vs_renewal, :monthly_registration_by_branch, :monthly_registration_by_job_type, :statistic_male_female
                    get :input_error_critical_amendment

                    # Pati Monthly Reports
                    get :pati_registration_monthly_country_by_month, :pati_registration_monthly_branch_by_month

                    # Misc Reports
                    get :employer_registration_by_state, :total_change_clinic, :total_amendment_cases, :branch_collection

                    # Insurance Reports
                    get :details_worker_insurance
                end
            end

            resources :hcm_reports, only: [:index] do
                collection do
                    # HCM Reports
                    get :total_workers_registered_by_branch, :number_of_errors
                end
            end

            resources :insurance_reports, only: [:index] do
                collection do
                    # Insurance Reports
                    get :summary_worker_insurance, :details_worker_insurance
                end
            end

            resources :documents, only: [] do
                collection do
                    get "check", to: "documents#check", as: "check"
                end

                member do
                    get  "/", to: "documents#document", as: "document"
                end
            end

            resources :it_reports, only: [:index] do
                collection do
                    get "daily_thumbprint_tested","insurance_purchase","summary_insurance_purchase","insurance_purchased_daily", "insurances"

                    # Biodata
                    get :daily_getbiodata_report, :daily_afisid_report, :daily_biometric_report, :daily_myimms_error_report

                    # Medical
                    get :it_send_mail_for_unsuitable
                end
            end

            resources :finance_reports, only: [:index] do
                collection do
                    get :sp_payment_mode_statistic, :summary_draft_collection, :summary_worker_certification, :detail_worker_certification,
                    :summary_worker_registration, :detail_worker_registration, :summary_misc_income, :portal_transactions, :summary_doctor_certification,
                    :summary_laboratory_certification, :summary_xray_certification, :doctor_certification_details,
                    :laboratory_certification_details, :xray_certification_details, :xray_not_done_certifications,
                    :laboratory_certification_by_gender, :laboratory_not_done_certification, :summary_worker_insurance, :details_worker_insurance, :employer_account,
                    :summary_transaction_expired_without_examination, :detail_transaction_expired_without_examination,
                    :summary_transaction_transmission_expired, :detail_transaction_transmission_expired, :daily_refund_payment_failed_reminder
                end
            end

            resources :operation_reports, only: [:index] do
                collection do
                    get :monthly_registration_by_job_type, :monthly_registration_by_branch, :health_screening_statistics,
                        :daily_branch_registration, :daily_monthly_registration_with_ytd,
                        :daily_branch_registration_cronjob, :daily_branch_registration_interim_cronjob,
                        :daily_monthly_registration_with_ytd_cronjob, :regpatiday, :details_worker_insurance, :daily_monthly_worker_insurance

                    # Statistik Saringan Kesihatan
                    get :statistik_mengikut_sektor, :statistik_mengikut_negeri, :statistik_mengikut_negara_sumber, :statistik_mengikut_tahun, :statistik_mengikut_sebab

                    # Monthly Certification Reports
                    get :branch_monthly_diseases, :branch_monthly_status, :branch_monthly_country_status, :pati_certification_monthly_diseases
                end
            end

            resources :mspd_reports, only: [:index] do
                collection do
                    get :worker_block_send_to_jim, :list_doc_register, :list_xray_register, :list_lab_register,
                        :foreign_worker_registrations, :unsuitable_foreign_workers, :suspended_doctors,
                        :lab_delay_transmission, :xray_delay_transmission, :gp_unutilized_quota, :mclx_report,
                        :radiographer_report, :xray_delay_transactions, :doctor_delay_transactions, :laboratory_delay_transactions,:doctor_information, :lab_allocation, :list_of_workers_by_doctor, :xray_allocation_to_radiologist,
                        :list_of_xray, :list_of_laboratories, :list_of_gp, :clinic_allocation_to_xray_and_lab, :quota_summary

                    # Moh Monthly Medical Reports
                    get :fomema2a_reports, :fomema2b_reports, :fomema3a_reports, :fomema3b_reports, :fomema4b_reports, :fomema2b_cumulative_reports, :fomema3b_cumulative_reports, :fomema4b_cumulative_reports

                    # Wrong Transmission Reports
                    get :wrong_transmission_doctor, :wrong_transmission_lab, :wrong_transmission_xray, :non_transmission_doctor, :non_transmission_doctor_items

                    # Reports Diff Bloodgroup
                    get :different_blood_group_by_doctor, :different_blood_group_by_lab

                    get :full_quota, :daily_balance_quota
                    get :new_dxlr
                    get :active_dxlr
                    get :mspd_suspension
                end
            end

            resources :xqcc_reports, only: :index do
                collection do
                    # Gan's reports
                    get :radiographer_daily_summary, :pcr_audit_summary, :xqcc_quality_summary, :xqcc_daily_total_xray_received, :xqcc_daily_total_xray_received_by_certification, :xqcc_digital_xray_certified, :xqcc_daily_dispatch_list, :xqcc_daily_film_review, :xqcc_pending_radiographer_report, :daily_non_compliance_report, :daily_non_compliance_report_download, :xqcc_monthly_xray_received_and_viewed, :radiographer_pending_review_report, :xqcc_monthly_non_compliance_report, :xqcc_dx_film_confirmed_as_abnormal, :xqcc_dx_pending_audit_pcr, :xqcc_dx_audit_statistics, :xqcc_digital_xray_tat_review, :xqcc_daily_boxes_store, :xqcc_daily_film_store, :xqcc_summary_pending_review, :xqcc_misread, :xqcc_detail_misread, :pcr_audit_summary_report

                    # Xqcc Misc (This is from MSPD reports, not sure why)
                    get :weekly_radiographer_receive_review_auto_release

                    # Radiographer reports
                    get :radiographer_monthly_summary_report

                    # Misc Reports
                    get :xqcc_result_release_pending_decision, :xqcc_result_release_amend_cases, :xqcc_amend_unsuitable_report, :monthly_xqcc_programme_report
                end
            end

            resources :pcr_reports, only: [:index] do
                collection do
                    get :pcr_audit_summary, :xqcc_pending_audit_pcr_report
                end
            end

            resources :inspectorate_reports, only: [:index] do
                collection do
                    get :master_list, :visit_plan_request, :by_state, :by_insp, :visited_statistic, :non_compliance_clinic, :non_compliance_xray, :search_service_provider

                    ## master list
                    get 'master_list/new', to: "inspectorate_reports#new_master_list", as: "new_master_list"
                    post 'master_list/create', to: "inspectorate_reports#create_master_list", as: "create_master_list"
                    get "master_list/:id", to: 'inspectorate_reports#view_master_list', as: "view_master_list"
                    get "master_list/:id/:item_id", to: 'inspectorate_reports#edit_master_list', as: "edit_master_list"
                    patch "master_list/:id/:item_id", to: 'inspectorate_reports#update_master_list'

                    ## visit_plan_request
                    get 'visit_plan_request/new', to: "inspectorate_reports#new_visit_plan_request", as: "new_visit_plan_request"
                    post 'visit_plan_request/create', to: "inspectorate_reports#create_visit_plan_request", as: "create_visit_plan_request"

                    get 'visit_plan_request/:id', to: "inspectorate_reports#show_visit_plan_request", as: "show_visit_plan_request"
                    get "visit_plan_request/:id/edit", to: 'inspectorate_reports#edit_visit_plan_request', as: "edit_visit_plan_request"
                    patch "visit_plan_request/:id/edit", to: 'inspectorate_reports#update_visit_plan_request'
                end
            end

            resources :lqcc_reports, only: [:index] do
                collection do
                    get :master_list

                    get 'master_list/:id/edit', to: "lqcc_reports#edit_master_list", as: "edit_master_list"
                    patch "master_list/:id/edit", to: 'lqcc_reports#update_master_list'
                end
            end

            resources :customer_service_reports, only: [:index] do
                collection do
                    get :bypass_biometric_summary, :bypass_biometric_detail, :bypass_biometric_request_detail
                end
            end

            resources :order_payments do
                member do
                    get 'hold'
                    post 'hold', to: 'order_payments#hold_update'
                    get 'unhold'
                    patch 'unhold', to: 'order_payments#unhold_update'

                    get 'bad'
                    get 'unbad'

                    get 'replace'
                    patch 'replace', to: 'order_payments#replace_update'
                end

                collection do
                    get 'check_unique_cimb'
                end
            end

            #insurance in nios

            resources :insurances, only: [] do
                collection do
                    get "submit_calculator/:order_id", to: "insurances#submit_calculator", as: "submit_calculator"
                    post "premium_calculated", to: "insurances#premium_calculated", as: "premium_calculated"
                    get "submit_paid_premium/:order_id", to: "insurances#submit_paid_premium", as: "submit_paid_premium"
                    post "policy", to: "insurances#policy", as: "policy"
                    post "insurance_orders", to: "insurances#insurance_orders", as: "insurance_orders"
                end
            end

            resources :pcr_review_reports, only: [:show]

            get 'profile', to: "profiles#profile", as: "profile"
            put 'profile', to: "profiles#profile_update", as: "profile_update"
            get 'password', to: "profiles#password", as: "password"
            put 'password', to: "profiles#password_update", as: "password_update"

            get 'sample', to: 'home#sample'
            get 'notifications/index'
            resources :approvals, only: [:edit]
            root to: "home#dashboard"
            
            # /dashboard settings
            namespace :dashboards_settings do
                get 'customer_survey_upload' => "customer_survey_upload#customer_satisfaction"
                post 'customer_survey_upload' => "customer_survey_upload#customer_satisfaction"               
            end
        end
        # /internal module
    end

    # For merts & portal subdomains.
    constraints subdomain: [ENV["SUBDOMAIN_PORTAL"].downcase, ENV["SUBDOMAIN_MERTS"].downcase] do
        # external module
        scope module: "external", as: "external" do

            devise_for :users, as: 'external', controllers: {
                sessions: 'external/users/sessions',
                registrations: 'external/users/registrations',
                passwords: 'external/users/passwords',
                confirmations: 'external/users/confirmations'
            }

            get 'users/activate' => 'users#activate'
            resources :employers do
                collection do
                    get 'registered'
                    get 'new_account'
                    post 'create_new_account'

                    get 'sign-up', to: 'employers#sign_up'
                    post 'sign-up', to: 'employers#sign_up_create'
                    get 'signed-up', to: 'employers#signed_up'
                    get 'registration'
                    get 'reregistration'
                    patch 'reregistration', to: 'employers#reregistration_update'
                end
            end

            resources :agencies do
                collection do
                    get 'registered'
                    get 'new_account'
                    post 'create_new_account'

                    get 'sign-up', to: 'agencies#sign_up'
                    post 'sign-up', to: 'agencies#sign_up_create'
                    get 'signed-up', to: 'agencies#signed_up'
                    get 'registration'
                    get 'reregistration'
                    patch 'reregistration', to: 'agencies#reregistration_update'

                    get 'agency_agreement'
                    get 'agency_sop'
                end
            end


            resources :agency_employers do

                resources :audits, only: [:index, :show]
                resources :employer_documents
            end
            # /employers

            get 'sp-login', to: 'sp_login#login', as: 'sp_login'

            resources :email_resets, only: [:new, :create] do
            end

            resources :favourite_radiologists do
                collection do
                    post 'bulk_action', to: 'favourite_radiologists#bulk_action'
                end
            end

            resources :worker_lists do
                collection do
                    post 'bulk_action', to: 'worker_lists#bulk_action'
                    get 'bulk_upload_template', to: 'worker_lists#bulk_upload_template'
                    get 'bulk_upload_specification', to: 'worker_lists#bulk_upload_specification'
                    get 'bulk_upload', to: 'worker_lists#bulk_upload'
                    post 'bulk_upload', to: 'worker_lists#bulk_upload_store'
                    post 'bulk_upload_preview', to: 'worker_lists#bulk_upload_preview'
                    get 'bulk_transfer_worker', to: 'worker_lists#bulk_transfer_worker'
                    post 'bulk_transfer_worker', to: 'worker_lists#bulk_transfer_worker_update'
                    get 'filter_supplement', to: 'worker_lists#filter_supplement'
                end
                member do
                    get 'revert'
                    patch 'revert', to: 'worker_lists#revert_update'
                    get 'change_employer_revert'
                    patch 'change_employer_revert', to: 'worker_lists#change_employer_revert_update'
                end
            end

            resources :agency_workers do
                collection do
                    post 'bulk_action', to: 'agency_workers#bulk_action'
                    get 'bulk_upload_template', to: 'agency_workers#bulk_upload_template'
                    get 'bulk_upload_specification', to: 'agency_workers#bulk_upload_specification'
                    get 'bulk_upload', to: 'agency_workers#bulk_upload'
                    post 'bulk_upload', to: 'agency_workers#bulk_upload_store'
                    post 'bulk_upload_preview', to: 'agency_workers#bulk_upload_preview'
                end
                member do
                    get 'revert'
                    patch 'revert', to: 'agency_workers#revert_update'
                    get 'edit_address'
                    patch 'edit_address', to: 'agency_workers#update_address'
                    get 'change_employer_revert'
                    patch 'change_employer_revert', to: 'worker_lists#change_employer_revert_update'
                end
            end

            resources :foreign_workers, only: [:index]

            post "orders/fpx_payment_status"
            post "orders/fpx_payment_status_backend"

            resources :orders do
                member do
                    get 'payment'
                    patch 'payment', to: 'orders#payment_update'

                    post 'fpx_payment', to: 'orders#fpx_payment'
                    get 'fpx_payment_confirmation',  to: "orders#fpx_payment_confirmation", as: "fpx_payment_confirmation"

                    post 'payment_status'
                    post 'payment_status_backend'
                    post 'swipe_payment_status'
                    post 'swipe_payment_status_backend'
                    post 'boleh_payment_status'
                    post 'boleh_payment_status_backend'

                    get 'invoice', to: 'orders#invoice', as: 'invoice'

                    get "remove-order-item/:oi_id", to: "orders#remove_order_item", as: "remove_order_item"

                    get 'swipe_user_guide'
                    get 'boleh_user_guide'
                end
            end

            resources :refunds, only: [:index, :show]

            resources :transactions do
                collection do
                    # get ':id/cancel', to: 'transactions#cancel', as: 'cancel'
                    # patch ':id/cancel', to: 'transactions#cancel_update'
                    get ':id/medical-examination', to: 'transactions#medical_examination', as: 'medical_examination'
                    patch ':id/medical-examination', to: 'transactions#medical_examination_update'
                    post "assign_doctors", "filter_doctors"
                    post 'verify_fingerprint', to: 'transactions#verify_fingerprint'

                    get ":id/medical_examination_retake", to: "transactions#medical_examination_retake", as: "medical_examination_retake"
                    patch ":id/medical_examination_retake", to: "transactions#medical_examination_retake_update"

                    get 'bulk_print_medical_form'

                    # insurance
                    get "/get_insurance_data", to: "transactions#get_insurance_data", as: "get_insurance_data"
                end

                member do
                    get   "cancel", "medical_form_print", "unsuitable_slip", "tcupi_review", "examination_history", "report_print", "previous_examination_history", "upload_doc", "reupload_doc", "appeal_pdpa_form", "appeal_agency_pdpa_form","view_tcupi","tcupi_audit_case_letter", "tcupi_nonaudit_case_letter", "medical_report_letter", "remove_exam_date", "special_renewal_authorisation_letter"
                    get "bypass_fingerprint"
                    post  "tcupi_review_post"
                    patch "cancel", to: "transactions#cancel_update"
                    patch "upload_doc", to: "transactions#upload_doc"
                    patch "reupload_doc", to: "transactions#reupload_doc"
                    patch "view_tcupi", to: "transactions#view_tcupi"
                    patch "remove_exam_date", to: "transactions#remove_exam_date_update"
                    patch 'bypass_fingerprint_update', to: 'transactions#bypass_fingerprint_update'
                end
            end

            resources :retakes do
                member do
                    get "bypass_fingerprint"
                    patch 'bypass_fingerprint_update', to: 'retakes#bypass_fingerprint_update'
                end
            end

            # insurance - for insurance provider
            post "insurancepurchases.php", to: "transactions#insurance_purchase", as: "insurance_purchase"

            resources :insurance_histories, only: [:index, :show]

            resources :appeals, only: [:index, :show, :new, :create, :update] do
                member do
                    get "appeal_employer_decision_letter", "appeal_doctor_instruction_letter"
                    patch "submit_xray_exam"
                    get "upload_document"
                    patch "upload_document_update", to: "appeals#upload_document_update"
                    get "show_appeal_todos"
                end
            end

            resources :laboratory_certified_transactions, only: [:index]

            # get 'faq' => 'public/faq'
            scope module: 'visitor' do
                get 'faq', to: 'faq'
                get 'pdpa', to: 'pdpa'
            end

            get 'states/:id/postcodes', to: '/internal/states#postcodes', as: "state_postcodes"
            get 'states/:id/towns', to: '/internal/states#towns', as: "state_towns"

            get 'postcodes/:id/towns_by_code', to: '/internal/postcodes#towns_by_code', as: "postcode_towns"

            # get 'bulletins', to: 'bulletins#index', as: "bulletins"
            # get 'bulletins/:id', to: 'bulletins#show', as: "bulletin"
            # get 'bulletins/:id/acknowledge', to: 'bulletins#acknowledge', as: 'acknowledge'
            resources :bulletins, only: [:index, :show] do
                member do
                    get 'acknowledge'
                end
            end

            resources :xray_images, only: [:index] do
                collection do
                    post "search_image", "delete_image"
                end
            end

            resources :reported_cases, only: [:index] do
                collection do
                    get "view"
                end
            end

            resources :arl_emails, only: [:index] do
                collection do
                    post 'bulk_action', to: 'arl_emails#bulk_action'
                end
            end

            resources :amended_notifiable_transactions, only: [:index] do
                collection do
                end
            end

            resources :quality_summary_reports, only: [:index] do
                collection do
                    get  :merts_quality_summary
                end
            end

            resources :home, only: [] do
                collection do
                    get :doctor_dashboard_statistics, :laboratory_dashboard_statistics, :xray_facility_dashboard_statistics, :employer_dashboard_statistics
                end
            end

            resources :insurances, only: [] do
                collection do
                    get "submit_calculator/:order_id", to: "insurances#submit_calculator", as: "submit_calculator"
                    post "premium_calculated", to: "insurances#premium_calculated", as: "premium_calculated"
                    get "submit_paid_premium/:order_id", to: "insurances#submit_paid_premium", as: "submit_paid_premium"
                    post "policy", to: "insurances#policy", as: "policy"
                    post "insurance_orders", to: "insurances#insurance_orders", as: "insurance_orders"
                end
            end

            resources :fw_change_employers, only: [:index, :show]

            get 'profile', to: "profiles#profile", as: "profile"
            put 'profile', to: "profiles#profile_update", as: "profile_update"
            get 'password', to: "profiles#password", as: "password"
            put 'password', to: "profiles#password_update", as: "password_update"
            root to: "home#dashboard"
        end
        # /external module
    end

    # Only used for Lab Web Services - Joey
    constraints subdomain: ENV["SUBDOMAIN_LABWS"].downcase do
        scope path: "LabTransactionWS/services", module: :external, as: :labws do
            # Original implementation from wash_out gem. Keeping here as reference because it was confusing to figure out initially.
            # match "LabTransactionWS" => "soap_laboratories#_generate_wsdl", via: :get, format: false, as: "external/soap_laboratories_wsdl"
            # match "LabTransactionWS/action" => WashOut::Router.new("external/soap_laboratories"), via: [:get, :post], defaults: { controller: "external/soap_laboratories", action: "soap" }, format: false, as: "external/soap_laboratories_soap"

            match "LabTransactionWS.*all" => WashOut::Router.new("external/soap_laboratories"), via: [:post], defaults: { controller: "external/soap_laboratories", action: "soap" }, format: false, as: "external/soap_laboratories_soap"
        end

        # This is used for the soap xml. Has to be defined separately from the POST requests due to the gem.
        scope path: "LabTransactionWS/services", module: "external", as: "labws_revamp" do
            get "LabTransactionWS", to: "soap_laboratories_revamp#get_xml"
        end

        get 'ip', to: 'internal/home#ip', as: 'niosws_ip'
    end

    # Only used for Xray Web Services - Fathur
    constraints subdomain: ENV["SUBDOMAIN_XRAYWS"].downcase do
        scope path: "ws/services", module: :external, as: :xrayws do
            # match "TransactionIdService" => "soap_xrays#_generate_wsdl", via: :get, format: false, as: "external/soap_xrays_wsdl"
            # match "TransactionIdService/action" => WashOut::Router.new("external/soap_xrays"), via: [:get, :post], defaults: { controller: "external/soap_xrays", action: "soap" }, format: false, as: "external/soap_xrays_soap"

            match "TransactionIdService.*all" => WashOut::Router.new("external/soap_xray_salinees"), via: [:post], defaults: { controller: "external/soap_xray_salinees", action: "soap" }, format: false, as: "external/soap_xrays_soap"
        end

        # This is used for the soap xml.
        scope path: "ws/services", module: "external", as: "xrayws" do
            get     "TransactionIdService", to: "soap_xrays_revamp#get_xml"
        end

        get 'ip', to: 'internal/home#ip', as: 'fomws_ip'
    end

    resources :shared, only: [] do
        collection do
            get     "view_xray_image"
            post    "check_for_user_account", "search_for_xray_facilities", "search_for_doctors", "get_xray_taken_date", "check_to_update_image_status"
        end
    end

    namespace :api do
        namespace :v1 do
            resources :finance do
                collection do
                    post 'ap_invoice_batches/update', to: "finance#ap_invoices_update", as: "ap_invoices_update"
                end
            end

            resources :transaction_emails do
                collection do
                    post 'result_email_sent/update', to: "transaction_emails#patch_email_sent", as: "patch_email_sent"
                end
            end

        end
    end

    ## for sage testing purposes
    get "daily_collection", to: "sage_tests#daily_collection"
    get "daily_revenue", to: "sage_tests#daily_revenue"
    get "daily_void_collection", to: "sage_tests#daily_void_collection"
    get "daily_revenue_batch", to: "sage_tests#daily_revenue_batch"
    ## end

    ## patch external transaction data
    get "patch_external_transactions", to: "patches#patch_external_transactions"
    ##
     ## dashboards routing
    namespace :dashboards do
        get 'fw_information', to: 'fw_information#index'
        namespace :fw_information do
         get 'index'
         get 'registration_counts'
         get 'registration_by_states'
         get 'registration_by_sectors'
         get 'registration_by_countries'
         get 'registration_trends'
        end
        get 'geographical', to: 'geographical#index'
        namespace :geographical do
            get 'index'
            get 'towns'
            get 'filter'
        end
        get 'dep_information', to: 'dep_information#index'
        namespace :dep_information do
            get 'third_db_data'
            get 'index'
            get 'filter_kpi'
        end
        get 'customer_satisfaction', to: 'customer_satisfaction#index'
        namespace :customer_satisfaction do
            get 'filterapply'
            get 'index'
        end
        get 'service_provider', to: 'service_provider#index'
        scope :service_provider do
            get 'index', to: 'service_provider#index'
            get 'quota_usage_by_doctor', to: 'service_provider#quota_usage_by_doctor'
            get 'certification_by_doctor', to: 'service_provider#certification_by_doctor'
            get 'laboratory_result_transmission', to: 'service_provider#laboratory_result_transmission'
            get 'xray_transmission', to: 'service_provider#xray_transmission'
            get 'xray_compliance', to: 'service_provider#xray_compliance'
            get 'accuracy_transmission', to: 'service_provider#accuracy_transmission'
            get 'apply_filter', to: 'service_provider#apply_filter'
        end
        get 'districts/:districtname' => 'geographical#statevalues'
        get 'districtname/:districtvalue' => 'geographical#districtvalues'
        post 'refresh_dashboards' => 'refresh_dashboards#create'
        get 'refresh_dashboards' => 'refresh_dashboards#get_interval'
       
        ##excel-generate
        resources :fw_information ,only: [:index] do 
             collection do
                 match 'excel_generate', to: 'fw_information#excel_generate', via: [:get, :post], defaults: { format: :xlsx }
             end 
        end
        ##end
    end         
     ##end

end