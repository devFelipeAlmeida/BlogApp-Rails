class RemovePostIdFromTags < ActiveRecord::Migration[7.2]
  def change
    remove_column :tags, :post_id, :integer
  end
end
