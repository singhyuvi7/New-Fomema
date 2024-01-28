module Internal
    class EmployerDocumentsController < InternalController
        before_action :set_employer
        before_action :set_document, only: [:show, :edit, :update, :destroy]

        def index
            @uploads = @employer.uploads.page(params[:page]).per(get_per)
        end

        def show
        end

        def new
        end

        def create

            if params[:employer][:uploads].present?
                params[:employer][:uploads].each do |upload|
                    if (!upload[:documents].nil?)
                        upl = @employer.uploads.create()
                        upl.documents.attach(upload[:documents])
                    end
                end
            end

            flash[:notice] = "Document was successfully uploaded.";
            redirect_to internal_employer_employer_documents_path

        end

        def edit
        end

        def update
        end

        def destroy
            @document.destroy
            respond_to do |format|
                format.html { redirect_to internal_employer_employer_documents_path, notice: 'Document was successfully destroyed.' }
                format.json { head :no_content }
            end
        end

        private
        def set_employer
            @employer = Employer.find(params[:employer_id])
        end

        def set_document
            @document = @employer.uploads.find(params[:id])
        end
    end
    # /class
end
# /module