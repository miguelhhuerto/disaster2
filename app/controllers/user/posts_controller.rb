class User::PostsController < ApplicationController
    def index
        require 'csv'    
        #import
        # CSV.foreach("filename", headers: true) do |row|
            # Moulding.create!(row.to_hash)
        # end

        @posts = current_user.posts.page(params[:page]).per(5)
        respond_to do |format|
            format.html
            format.csv {
            csv_string = CSV.generate do |csv|
              csv << [
              Post.human_attribute_name(:id), Post.human_attribute_name(:title), Post.human_attribute_name(:content),
              Post.human_attribute_name(:categories), Post.human_attribute_name(:address), Post.human_attribute_name(:address_region_id),
              Post.human_attribute_name(:address_province_id), Post.human_attribute_name(:address_city_id), Post.human_attribute_name(:address_barangay_id),
              Post.human_attribute_name(:created_at)
              ]
        
              @posts.each do |p|
                csv << [
                p.id, p.title, p.content, 
                p.categories.pluck(:name).join(','),p.address,p.address_region_id,p.address_province_id,p.address_city_id,p.address_barangay_id, p.created_at
                ]
              end
            end
          render plain: csv_string
          }
          end
    end

    def edit
        authorize @post, :edit?, policy_class: PostPolicy
    end
    
    def update
    authorize @post, :update?, policy_class: PostPolicy
    if @post.update(post_params)
        flash[:notice] = 'Post updated successfully'
        redirect_to posts_path
    else
        flash.now[:alert] = 'Post update failed'
        render :edit, status: :unprocessable_entity
    end
    end
end