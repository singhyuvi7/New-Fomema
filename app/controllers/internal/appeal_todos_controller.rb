class Internal::AppealTodosController < InternalController
  before_action :set_appeal_todo, only: [:show, :edit, :update, :destroy]

  # GET /appeal_todos
  # GET /appeal_todos.json
  def index
    @appeal_todos = AppealTodo.search_description(params[:description])
    .page(params[:page])
    .per(get_per)
  end

  # GET /appeal_todos/1
  # GET /appeal_todos/1.json
  def show
  end

  # GET /appeal_todos/new
  def new
    @appeal_todo = AppealTodo.new
  end

  # GET /appeal_todos/1/edit
  def edit
  end

  # POST /appeal_todos
  # POST /appeal_todos.json
  def create
    @appeal_todo = AppealTodo.new(appeal_todo_params)

    respond_to do |format|
      if @appeal_todo.save
        format.html { redirect_to internal_appeal_todos_url, notice: 'Appeal todo was successfully created.' }
        format.json { render :show, status: :created, location: @appeal_todo }
      else
        format.html { render :new }
        format.json { render json: @appeal_todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appeal_todos/1
  # PATCH/PUT /appeal_todos/1.json
  def update
    respond_to do |format|
      if @appeal_todo.update(appeal_todo_params)
        format.html { redirect_to internal_appeal_todos_url, notice: 'Appeal todo was successfully updated.' }
        format.json { render :show, status: :ok, location: @appeal_todo }
      else
        format.html { render :edit }
        format.json { render json: @appeal_todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appeal_todos/1
  # DELETE /appeal_todos/1.json
  def destroy
    @appeal_todo.destroy
    respond_to do |format|
      format.html { redirect_to internal_appeal_todos_url, notice: 'Appeal todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appeal_todo
      @appeal_todo = AppealTodo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appeal_todo_params
      params.require(:appeal_todo).permit(:description, :is_active)
    end
end
