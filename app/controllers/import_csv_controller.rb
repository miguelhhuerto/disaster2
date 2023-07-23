class ImportCsvController < ApplicationController
    def import
        if params[:file].present?
          require 'csv'
          CSV.foreach(params[:file].path, headers: true) do |row|
            Post.create(title: row['title'], content: row['content'], category: row['type'], address: row['address'], address_region_id: row['region'], address_province_id: row['province'], address_city_id: row['city'], address_barangay_id: row['barangay'])
          end
          redirect_to posts_path, notice: "CSV file imported successfully."
        else
          redirect_to posts_path, alert: "Please select a CSV file."
        end
    end
end