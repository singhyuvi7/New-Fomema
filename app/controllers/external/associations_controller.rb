class External::AssociationsController < ExternalController

      # GET /associations
      # GET /associations.json
      def index
        @associations = Association.search_code(params[:code])
      .search_description(params[:name])
      .page(params[:page])
      .per(get_per)
      end

      # GET /associations/new
      def new
        @association = Association.new
      end

      def show
      end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_association
        @association = Association.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def association_params
        params.require(:association).permit(:code, :name)
      end
end 
