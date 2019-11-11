class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :answers, :created_at, :updated_at, :shorten_title

  has_many  :links
  has_many  :comments
  has_many  :files, serializer: FileSerializer
  belongs_to :user

  def shorten_title
    object.title.truncate(6)
  end

  # overwrite answers method in attempt to prevent N+1 problem while getting answers with files
  def answers
    Answer.with_attached_files.where(question_id: object.id)
  end
end
