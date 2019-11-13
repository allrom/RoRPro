class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :shorten_title

  has_many :answers
  belongs_to :user
end
