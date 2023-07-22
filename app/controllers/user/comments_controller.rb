class User::CommentsController < ApplicationController
    
  def index
    @comments = current_user.comments.includes(:user)
  end

  def edit
    redirect_to edit_post_path
  end
end
