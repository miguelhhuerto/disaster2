class AddIpCityAndCountryToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :ip_city, :string, default: nil
    add_column :posts, :ip_country, :string, default: nil
  end
end
