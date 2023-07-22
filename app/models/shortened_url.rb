class ShortenedUrl < ApplicationRecord
    validates :short_code, presence: true, uniqueness: true
    before_validation :generate_unique_short_code

    private

    def generate_unique_short_code
        loop do
        random_number = format('%04d', rand(1..9999))
        unless ShortenedUrl.exists?(short_code: random_number)
            self.short_code = random_number
            break
        end
        end
    end
end