class Task < ApplicationRecord
    belongs_to :user

    validates :title, presence: true, length: { maximum: 120 } # limite 120 chars
end
