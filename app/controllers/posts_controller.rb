class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  require 'csv'   

  def index
    @posts = Post.includes(:categories, :user, :region, :province, :city, :barangay).all.page(params[:page]).per(5)
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

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if Rails.env.development?
      @post.ip_address = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    else
      @post.ip_address = request.remote_ip
    end
    if @post.save

      flash[:notice] = 'Post created successfully'
      redirect_to posts_path
    else
      flash.now[:alert] = 'Post create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def show;

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

  def destroy
    authorize @post, :destroy?, policy_class: PostPolicy
    @post.destroy
    flash[:notice] = 'Post destroyed successfully'
    redirect_to posts_path
  end

  def import
    if params[:file].present?
      require 'csv'
        data = params[:file].read
        rows = CSV.parse(data, headers: true)
        rows.each do |row|
          categories = row['type']&.split(',')&.map do |category_name|
            Category.find_by(name: category_name)
          end
          Post.create(
            title: row['title'],
            content: row['content'],
            categories: categories,
            address: row['address'],
            address_region_id: row['region'],
            address_province_id: row['province'],
            address_city_id: row['city'],
            address_barangay_id: row['barangay'],
            user: current_user
          )
        end 
        redirect_to posts_path, notice: "CSV file imported successfully."
    else
      redirect_to posts_path, alert: "Please select a CSV file."
    end
  end
  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :address, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id, category_ids: [])
  end
end
