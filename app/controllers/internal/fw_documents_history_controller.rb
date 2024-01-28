class Internal::FwDocumentsHistoryController < InternalController

    before_action :set_fw_documents_history, only: [:show]

    def index
    end

    def show
    end

    def new
    end

    def create
    end

    def edit
    end

    def update
    end

    def destroy
    end

    private
    def set_fw_documents_history
        @foreign_worker = ForeignWorker.find(params[:id])
    end
end