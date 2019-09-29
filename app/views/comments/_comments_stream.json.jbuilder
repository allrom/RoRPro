json.extract! comment, :id, :body, :user_id, :commentable_id

json.commentable_type comment.commentable_type.downcase
