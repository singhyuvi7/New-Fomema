class Internal::DocumentsController < InternalController

    before_action :set_upload, only: [:document]

    def document

        document = @upload.documents.find(params[:document_id])

        if document.blank?
            flash[:error] = "Document invalid"
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        else
            DocumentsUserViewLog.where(:upload_id => @upload.id, :document_id => document.id, :user_id => current_user.id).first_or_create

            redirect_to rails_blob_url(document) and return
        end
    end

    def check
        uploads = params[:type].classify.constantize.find(params[:id]).uploads

        view_count = DocumentsUserViewLog.where(:upload_id => uploads.pluck(:id), :user_id => current_user.id).count
        document_count = 0
        uploads.each do |upload|
            document_count += upload.documents.count
        end

        if view_count >= document_count
            has_viewed = true
        else
            has_viewed = false
        end

        render json: { has_viewed: has_viewed }, status: :ok
    end

private
    def set_upload
        @upload = Upload.find(params[:id])
    end
end
