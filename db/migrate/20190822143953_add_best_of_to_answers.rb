class AddBestOfToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column(:answers, :best, :boolean, null: false, default: false)
    add_index(:answers, :best, where: "best is true")
  end
end
