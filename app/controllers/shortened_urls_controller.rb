class ShortenedUrlsController < ApplicationController
    def redirect_to_post
        @post = Post.find_by(shorten_url: params[:shorten_url])
    
        if @post
          redirect_to @post
        else
          redirect_to root_path, notice: 'Post not found'
        end
      end
end
