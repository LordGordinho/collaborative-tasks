class TasksController < ApplicationController
    before_action :authenticate_user!

  def index
    tasks = current_user.tasks
    render json: { tasks: tasks }, status: 200
  end

  def show
    task = current_user.tasks.find(params[:id])
    render json: { task: task }, status: 200
  end

  def create
    task = current_user.tasks.build(task_params)
    if task.save
      render json: { task: task}, status: 201
    else
      render json: { errors: task.errors }, status: 422
    end
  end

  def update
    task = current_user.tasks.find(params[:id])
    if task.update(task_params)
      render json: { task: task }, status: 200
    else
      render json: { errors: task.errors }, status: 422
    end
  end

  def destroy
    task = current_user.tasks.find(params[:id])
    task.destroy
    head 204
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :done, :list_id)
  end
end
