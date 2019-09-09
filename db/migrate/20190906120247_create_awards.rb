class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.string :name, null: false
      t.string :image_filename, null: false
      t.references :question, foreign_key: true, null: false, index: { name: "index_awards_on_question_id" }
      t.references :user, foreign_key: true, null: false, index: { name: "index_awards_on_user_id" }

      t.timestamps
    end
  end
end
