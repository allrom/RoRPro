class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :shorten_title

  has_many  :answers
  has_many  :links
  has_many  :comments
  has_many  :files, serializer: FileSerializer
  belongs_to :user

  def shorten_title
    object.title.truncate(6)
  end
end
