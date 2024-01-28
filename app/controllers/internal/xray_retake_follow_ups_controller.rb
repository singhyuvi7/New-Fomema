class Internal::XrayRetakeFollowUpsController < InternalController
    before_action :set_xray_retake

    def index
        @xqcc_comment = @xray_retake.follow_ups.new
    end
    
    def create
        XqccComment.transaction do
            @xray_retake.follow_ups.create(xqcc_comment_params)
            redirect_to internal_xray_retake_xray_retake_follow_ups_path(@xray_retake), notice: "Follow up created successfully"
        end
    end

    private
    def set_xray_retake
        @xray_retake = XrayRetake.find(params[:xray_retake_id])
    end

    def xqcc_comment_params
        params.require(:xqcc_comment).permit(:comment)
    end
end
