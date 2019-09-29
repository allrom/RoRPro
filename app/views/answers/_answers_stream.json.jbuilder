json.extract! answer, :id, :body, :user_id, :amount, :best?

json.name answer.class.name.humanize.downcase
json.question_user_id answer.question.user_id
json.files_attached answer.files.attached?
json.links_empty answer.links.empty?
