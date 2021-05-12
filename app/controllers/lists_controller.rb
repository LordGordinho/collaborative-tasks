class ListsController < ApplicationController
    before_action :authenticate_user!

    def index
        lists = current
    end
end
