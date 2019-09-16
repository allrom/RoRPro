class RemoveUserNullConstraintAward < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:awards, :user_id, true)
  end
end
