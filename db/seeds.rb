# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
categories_1 = Category.create([:name => 'COVID'])
categories_2 = Category.create([:name => 'Earthquake'])
categories_3 = Category.create([:name => 'Requirements'])

10.times do
    user = User.create!(email: Faker::Internet.email, password: 'qwer4321', password_confirmation: "qwer4321")
    puts "create user id: #{user.id}, email: #{user.email}"
end
20.times do |i|
    region = Address::Region.all.sample
    province = region.provinces.sample
    city = province.cities.sample
    barangay = city.barangays.sample
    user = User.all.sample
    category_choose = Category.all.sample(rand(1..3))
    ip = Faker::Internet.ip_v4_address
    puts "start create #{i} post"
    post = Post.create!(
      title: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph,
      categories: category_choose,
      user: user,
      address: Faker::Lorem.sentence,
      address_region_id: region.id,
      address_province_id: province.id,
      address_city_id: city.id,
      address_barangay_id: barangay.id,
      ip_address: ip,
      ip_city: Geocoder.search(ip).first&.city,
      ip_country: Geocoder.search(ip).first&.country
    )
    (1..20).to_a.sample.times do
        Comment.create!(content: Faker::Lorem.sentence, user: User.all.sample, post: post)
    end
    puts "finish #{i} post"
end