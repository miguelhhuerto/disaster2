class User::CommentsController < ApplicationController
    def index
        @comments = current_user.comments.includes(:user).page(params[:page]).per(5)
    end
end