class AddUserToQuestions < ActiveRecord::Migration[5.2]
  def change
    change_table :questions do |t|
      t.references :user, foreign_key: true, null: false, index: { name: "index_question_on_user_id" }
     end
  end
end
