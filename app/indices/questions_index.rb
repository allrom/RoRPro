ThinkingSphinx::Index.define :question, with: :active_record do
  # fields (as in database)
  indexes title, sortable: true   # alphabet sorting
  indexes body
  indexes user.email, as: :author, sortable: true   # as: <alias> for compound 'field'

  # attributes (as fields in database not involved in search, but used for sorting, grouping, etc.)
  has user_id, created_at, updated_at
end
