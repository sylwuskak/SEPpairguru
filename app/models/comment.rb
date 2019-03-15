class Comment < ApplicationRecord
    belongs_to :movie
    belongs_to :user

    validates :user, uniqueness: { scope: :movie}
end