class TasksController < ApplicationController
    include Authenticatable # Protegge le API con JWT.

    before_action :set_task, only: [ :update, :destroy ]

    # GET /tasks
    def index
        tasks = @current_user.tasks
        render json: tasks
    end

    # POST /tasks
    def create
        task = @current_user.tasks.new(task_params)
        if task.save
            render json: @task
        else
            render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # PUT /tasks/:id
    def update
        if @task.update(task_params)
            render json: @task
        else
            render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # DELETE /tasks/:id
    def destroy
        @task.destroy
    end

    private

    def set_task
        @task = @current_user.tasks.find_by(id: params[:id])
        render json: { error: "Task not found" }, status: :not_found unless @task
    end

    def task_params
        params.require(:task).permit(:title, :completed)
    end
end
