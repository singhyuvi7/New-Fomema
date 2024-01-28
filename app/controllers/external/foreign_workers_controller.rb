class External::ForeignWorkersController < ExternalController
    include ProfileInfoCheck
    include AgencySopAcknowledgeCheck

    before_action -> { can_access?('SEARCH_FOREIGN_WORKER') }
    before_action -> { pending_profile_update?(Employer.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Employer' }, only: [ :index]
    before_action -> { agency_sop_acknowledge_check?(Agency.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Agency' }, only: [ :index]
    # this page allows employers to search for foreign workers medical result
    # user can submit both worker codes and passport numbers
    def index
        worker_codes        = process_search_input(params[:code])
        passport_numbers    = process_search_input(params[:passport_number])
        return unless worker_codes.present? || passport_numbers.present?
        @results            = SearchForeignWorkerMedicalResultsService.call(worker_codes, passport_numbers)
    end
private
    def process_search_input(params_array)
        params_array.present? ? params_array.select(&:present?).map(&:strip).uniq : []
    end
end