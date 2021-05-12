class ListsController < ApplicationController
    before_action :authenticate_user!

    def index
        lists = current_user.lists
        render json: { lists: lists }, status: 200
    end

    def show
        list = current_user.lists.find(params[:id])
        if list
            render json: { list: list } , status: 200
        end
    end

    def create
        list = current_user.lists.build(list_params)

        if list.save
            render json: { list: list }, status: 201
        else
            render json: { errors: list.errors }, status: 422
        end
    end

    def update
        list = current_user.lists.find(params[:id])

        if list.update(list_params)
            render json: { list: list }, status: 200
        else
            render json: { errors: list.errors }, status: 422
        end
            
    end

    def destroy
        list = current_user.lists.find(params[:id])
        list.destroy
        render json: {}, status: 204
    end

    def get_all_tasks_on_list
        tasks = current_user.lists.find(params[:id]).tasks
        render json: { tasks: tasks}, status: 200
    end

    def get_all_users_of_list
        tasks = current_user.lists.find(params[:id]).tasks
        users = []
        tasks.each { |task| users << task.user}
        users.uniq!
        render json: { users: users }, status: 200
    end

    private

    def list_params
        params.require(:list).permit(:name, :user_id)
    end
end
