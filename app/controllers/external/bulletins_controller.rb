class External::BulletinsController < ExternalController
    before_action :set_bulletin, only: [:show]

    def index
        @bulletins = current_user.bulletins
        .order("created_at desc, publish_from desc")
        .page(params[:page])
        .per(get_per)
    end

    def show
        redirect_to external_root_path and return if @bulletin.blank?

        @bulletin_user_view_log = BulletinUserViewLog.where(user_id: current_user.id, bulletin_id: @bulletin.id).first_or_create

        @acknowledge_count = 0
        if @bulletin.require_acknowledge
            @acknowledge_count = @bulletin.bulletin_user_view_logs.where("user_id = ? and acknowledged is true", current_user.id).count
        end
    end

    def acknowledge
        BulletinUserViewLog.find(params[:bulletin_user_view_log_id]).update({
            acknowledged: true
        })

        render json: {result: true}
    end

    private
    def set_bulletin
        @bulletin = Bulletin.filter_date_and_audiences(current_user.userable_type, current_user.userable.id).where(id: params[:id]).first
    end
end
