class Internal::ActivitiesController < InternalController

    def index
        activities = PublicActivity::Activity

        unless params[:category].blank?

            category_key = get_category_key(params[:category])

            activities = activities.where("key LIKE ?", "%" + category_key + "%")
        end

        unless params[:owner_id].blank?

            owner_id = params[:owner_id]

            activities = activities.where(owner_id: owner_id)

        end

        unless params[:start_date].blank?

            start_date = params[:start_date]

            activities = activities.where("created_at >= ?", start_date)

        end

        unless params[:end_date].blank?

            end_date = params[:end_date]

            activities = activities.where("created_at <= ?", Time.parse(end_date) + 1.day)

        end

        @activities = activities.order(created_at: :desc)
            .page(params[:page])
            .per(get_per)

        # @users = User.all
    end

    def get_category_key(category)
        category_key = "#{category}."
    end

end