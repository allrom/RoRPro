class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.belongs_to :commentable, polymorphic: true

      t.references :user, foreign_key: true, null: false, index: { name: "index_comments_on_user_id" }
      t.timestamps
    end
  end
end
