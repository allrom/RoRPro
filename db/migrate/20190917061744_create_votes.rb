class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :number_of
      t.references :user, foreign_key: true, null: false, index: { name: "index_votes_on_user_id" }

      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end
  end
end
