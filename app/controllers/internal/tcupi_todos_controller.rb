class Internal::TcupiTodosController < InternalController
  before_action :set_tcupi_todo, only: [:show, :edit, :update, :destroy]

  # GET /tcupi_todos
  # GET /tcupi_todos.json
  def index
    @tcupi_todos = TcupiTodo.search_description(params[:description])
    .page(params[:page])
    .per(get_per)
  end

  # GET /tcupi_todos/1
  # GET /tcupi_todos/1.json
  def show
  end

  # GET /tcupi_todos/new
  def new
    @tcupi_todo = TcupiTodo.new
  end

  # GET /tcupi_todos/1/edit
  def edit
  end

  # POST /tcupi_todos
  # POST /tcupi_todos.json
  def create
    @tcupi_todo = TcupiTodo.new(tcupi_todo_params)

    respond_to do |format|
      if @tcupi_todo.save
        format.html { redirect_to internal_tcupi_todos_url, notice: 'TCUPI TODO was successfully created.' }
        format.json { render :show, status: :created, location: @tcupi_todo }
      else
        format.html { render :new }
        format.json { render json: @tcupi_todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tcupi_todos/1
  # PATCH/PUT /tcupi_todos/1.json
  def update
    respond_to do |format|
      if @tcupi_todo.update(tcupi_todo_params)
        format.html { redirect_to internal_tcupi_todos_url, notice: 'TCUPI TODO was successfully updated.' }
        format.json { render :show, status: :ok, location: @tcupi_todo }
      else
        format.html { render :edit }
        format.json { render json: @tcupi_todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tcupi_todos/1
  # DELETE /tcupi_todos/1.json
  def destroy
    @tcupi_todo.destroy
    respond_to do |format|
      format.html { redirect_to internal_tcupi_todos_url, notice: 'TCUPI TODO was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tcupi_todo
      @tcupi_todo = TcupiTodo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tcupi_todo_params
      params.require(:tcupi_todo).permit(:description, :is_active)
    end
end
