class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.references :user, foreign_key: true, null: false, index: { name: "index_auth_on_user_id" }

      t.string :provider, null: false
      t.string :uid, null: false

      t.index [ :provider, :uid ], name: "index_provider_uid_uniqueness", unique: true

      t.timestamps
    end
  end
end
