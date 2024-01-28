class Internal::BulletinsController < InternalController
    before_action :set_bulletin, only: [:show, :edit, :update, :destroy]

    before_action -> { can_access?("VIEW_BULLETIN") }, only: [:index, :show]
    before_action -> { can_access?("CREATE_BULLETIN") }, only: [:new, :create]
    before_action -> { can_access?("EDIT_BULLETIN") }, only: [:edit, :update]
	before_action -> { can_access?("DELETE_BULLETIN") }, only: [:destroy]
	
	before_action :set_is_pop_up_exist, only: [:new, :edit]

    # GET /bulletins
    # GET /bulletins.json
    def index
		@bulletins = Bulletin.search_title(params[:title])
		.search_modification_date(params[:modification_date])
		.search_publish_date_from_start_range(params[:publish_from_start_date])
		.search_publish_date_from_end_range(params[:publish_from_end_date])
		.search_publish_date_to_start_range(params[:publish_to_start_date])
		.search_publish_date_to_end_range(params[:publish_to_end_date])
		.search_require_acknowledge(params[:require_acknowledge])
		.search_is_pop_up(params[:is_pop_up])
		.page(params[:page])
		.per(get_per)
    end

    # GET /bulletins/1
    # GET /bulletins/1.json
    def show
    end

    # GET /bulletins/new
    def new
		@bulletin = Bulletin.new({
			publish_from: DateTime.now,
			require_acknowledge: false
		})
    end

    # POST /bulletins
    # POST /bulletins.json
    def create
		@bulletin = Bulletin.new(bulletin_params)

		respond_to do |format|
			if @bulletin.save

				# perform uploads
				if params[:bulletin][:uploads].present?
					params[:bulletin][:uploads].each do |upload|
					if (!upload[:documents].nil?)
						upl = @bulletin.uploads.create()
						upl.documents.attach(upload[:documents])
					end
					end
				end
				# end of uploads

				# bulletin_audiences
				sync_audiences
				# /bulletin_audiences

				format.html { redirect_to internal_bulletins_url, notice: 'Bulletin was successfully created.' }
				format.json { render :show, status: :created, location: @bulletin }
			else
				format.html { render :new }
				format.json { render json: @bulletin.errors, status: :unprocessable_entity }
			end
		end
    end

    # GET /bulletins/1/edit
	def edit
    end

    # PATCH/PUT /bulletins/1
    # PATCH/PUT /bulletins/1.json
	def update
		if !params[:bulletin_audiences].present?
			@bulletin.errors.add(:base, "Audience is required")
			render :edit and return
		end
		respond_to do |format|
			if @bulletin.update(bulletin_params)

				# uploads
				if params[:bulletin][:uploads].present?
					params[:bulletin][:uploads].each do |upload|
						if (!upload[:documents].nil?)
							upl = @bulletin.uploads.create()
							upl.documents.attach(upload[:documents])
						end
					end
				end

				if params[:remove_uploaded_file].present?
					ids       = params[:remove_uploaded_file].split(",")
					@bulletin.uploads.where(id: ids).destroy_all
				end
				# end of uploads

				# bulletin_audiences
				sync_audiences
				# /bulletin_audiences

				format.html { redirect_to internal_bulletins_url, notice: 'Bulletin was successfully updated.' }
				format.json { render :show, status: :ok, location: @bulletin }
			else
				format.html { render :edit }
				format.json { render json: @bulletin.errors, status: :unprocessable_entity }
			end
		end
	end
	
	def sync_audiences
		ba_ids = []
		params[:bulletin_audiences].each do |ba|
			bulletin_audience = @bulletin.bulletin_audiences.where({
				bulletin_audienceable_type: ba["bulletin_audienceable_type"],
				bulletin_audienceable_id: ba["bulletin_audienceable_id"]
			}).first_or_create
			ba_ids << bulletin_audience.id
		end
		@bulletin.bulletin_audiences.where("id not in (?)", ba_ids).destroy_all
	end

    # DELETE /bulletins/1
    # DELETE /bulletins/1.json
    def destroy
		@bulletin.destroy
		respond_to do |format|
			format.html { redirect_to internal_bulletins_url, notice: 'Bulletin was successfully destroyed.' }
			format.json { head :no_content }
		end
    end

    private
	# Use callbacks to share common setup or constraints between actions.
	def set_bulletin
		@bulletin = Bulletin.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def bulletin_params
		params.require(:bulletin).permit(:title, :content, :publish_from, :publish_to, :require_acknowledge, :is_pop_up)
	end

	# Only one pop up allow in the bulletin
	def set_is_pop_up_exist
		@is_pop_up_exist = Bulletin.where('is_pop_up = ? and publish_to >= ?',true, Date.today)
		if !@bulletin.blank?
			@is_pop_up_exist = @is_pop_up_exist.where.not(:id => @bulletin.id)
		end

		@is_pop_up_exist = @is_pop_up_exist.exists?
	end
end