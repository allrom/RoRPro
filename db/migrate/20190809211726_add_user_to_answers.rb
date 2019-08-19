class AddUserToAnswers < ActiveRecord::Migration[5.2]
  def change
    change_table :answers do |t|
      t.references :user, foreign_key: true, null: false, index: { name: "index_answers_on_user_id" }
     end
  end
end
