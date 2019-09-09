class Award < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :name, :image_filename, presence: true
end
