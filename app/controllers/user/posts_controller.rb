class User::PostsController < ApplicationController
    def index
        @posts = current_user.posts.page(params[:page]).per(5)
    end
end