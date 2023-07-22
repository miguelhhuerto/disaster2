class Post < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :title, presence: true
  validates :content, presence: true
  validates :address, presence: true
  before_validation :generate_unique_short_code

  has_shortened_urls
  has_many :comments
  has_many :post_category_ships
  has_many :categories, through: :post_category_ships

  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'address_city_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'

  def destroy
    update(deleted_at: Time.now)
  end

  def generate_unique_short_code
    loop do
      random_number = format('%04d', rand(1..9999))
      unless Post.exists?(shorten_url: random_number)
        self.shorten_url = random_number
        break
      end
    end
  end

  def full_url
    "/posts/#{self.shorten_url}"
  end
end