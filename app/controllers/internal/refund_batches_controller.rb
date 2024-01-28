class Internal::RefundBatchesController < InternalController
    include Sage
    include BankInfoCheck

    before_action :set_refund_batch, only: [:show, :destroy, :process_payment, :download]

    def index
        @batches = RefundBatch.search_code(params[:code])
        .search_status(params[:status])
        .search_date_range(params[:batch_date_start],params[:batch_date_end])
        .order('refund_batches.id DESC')
        .page(params[:page])
        .per(get_per)
    end

    def new 
        @refund_batch = RefundBatch.new
        @pass_dates = RefundBatch.select("to_char(start_date, 'YYYY-MM-DD') as from, to_char(end_date, 'YYYY-MM-DD') as to").as_json(:except => :id)
    end

    def create
        default_status = 'PENDING_SEND'
        start_date = params[:start_date]
        end_date = params[:end_date]

        refunds = Refund.where("refunds.status = ? and ((refunds.created_at BETWEEN ? AND ?) OR (refunds.approval_at BETWEEN ? AND ?))", default_status, start_date.to_date.beginning_of_day, end_date.to_date.end_of_day, start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)

        if refunds.blank?
            flash[:error] = "No refund in the date range selected"
            redirect_to (request.env["HTTP_REFERER"] || new_internal_refund_batch_path) and return
        end

        @refund_batch = RefundBatch.create({
            start_date: start_date,
            end_date: end_date,
            status: default_status
        })

        refunds.update({
           refund_batch: @refund_batch  
        })

        respond_to do |format|
            format.html { redirect_to internal_refund_batches_path, notice: "Refund Batch #{@refund_batch.code} successfully created" }
        end
    end

    def show
    end

    def destroy
        @refund_batch.refunds.update({
            refund_batch_id: nil
        })

        @refund_batch.destroy
        respond_to do |format|
            format.html { redirect_to internal_refund_batches_path, notice: "Refund batch #{@refund_batch.code} was successfully destroyed." }
            format.json { head :no_content }
        end
    end

    def process_payment
        has_pending = @refund_batch.refunds.where(:status => ['PENDING_SEND','PROCESS_FAILED'])
        if !has_pending.blank?
            has_pending.update({
                status: 'PROCESSING'
            })    
            RefundBatchWorker.perform_async(@refund_batch.id)

            notice = "PROCESSING REFUND(S)"
        else
            notice = "UNABLE TO PROCESS REFUND"
        end
        redirect_back fallback_location: internal_refund_batch_path(@refund_batch), notice: notice
    end

    def download
        filename = 'Refund_Batch_'+@refund_batch.code+'('+@refund_batch.start_date.strftime("%Y%m%d")+'-'+@refund_batch.end_date.strftime("%Y%m%d")+').xlsx'
        respond_to do |format|
          format.html { redirect_to internal_refund_batch_path(@refund_batch) }
          format.xlsx do
            render xlsx: 'index', filename: filename, template: 'internal/refund_batches/index'
          end
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_refund_batch
        @refund_batch = RefundBatch.find(params[:id])
    end
end
