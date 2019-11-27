ThinkingSphinx::Index.define :user, with: :active_record do
  # fields (as in database)
  indexes email, sortable: true

  # attributes
  has admin, created_at, updated_at
end
