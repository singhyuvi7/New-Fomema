class External::XrayLicensePurposesController < ApplicationController
      # GET /XrayLicensePurposes
      # GET /XrayLicensePurposes.json
      def index
        @XrayLicensePurposes = XrayLicensePurposes.search_name(params[:name])
      .page(params[:page])
      .per(get_per)
      end

      # GET /XrayLicensePurposes/new
      def new
        @XrayLicensePurposes = XrayLicensePurposes.new
      end

      def show
      end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_xray_license_purposes
        @XrayLicensePurposes = XrayLicensePurposes.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def xray_license_purposes_params
        params.require(:XrayLicensePurposes).permit(:name)
      end
end
