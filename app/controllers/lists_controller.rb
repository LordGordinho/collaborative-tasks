class ListsController < ApplicationController
    before_action :authenticate_user!

    def index
        lists = current_user.lists
        render json: { lists: lists }, status: 200
    end

    def show
        list = current_user.list.find(params[:id])
        if list
            render json: { list: list } , status: 200
        end
    end

    private

    def list_params
        params.require(:list).permit(:name, :user_id)
    end
end
