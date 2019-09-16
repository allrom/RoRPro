class RemoveColumnAwardImage < ActiveRecord::Migration[5.2]
  def change
    remove_column(:awards, :image_filename)
  end
end
