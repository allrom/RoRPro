class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.text :body, null: false
      t.references :question, foreign_key: true, null: false, index: { name: "index_answers_on_question_id" }
      t.timestamps
    end
  end
end
