class AddShortUrlToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :shorten_url, :string, default: nil
  end
end
