module DocumentViewCheck

    def has_viewed?(viewable)

        uploads = viewable.uploads

        view_count = DocumentsUserViewLog.where(:upload_id => uploads.pluck(:id), :user_id => current_user.id).count
        document_count = 0

        uploads.each do |upload|
            document_count += upload.documents.count
        end

        if view_count < document_count
            flash[:error] = "Please review all the uploaded document(s) before approval."
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        end
    end
end