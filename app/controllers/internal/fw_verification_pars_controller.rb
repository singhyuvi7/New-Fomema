class External::FwVerificationParsController < InternalController
  before_action :set_fw_verification_par, only: [:show]


      def index
      end

      def new
      end

      def show
      end

    private
      def set_fw_verification_par
        @fw_verification_par= FwVerificationPar.find(params[:id])
      end

end
