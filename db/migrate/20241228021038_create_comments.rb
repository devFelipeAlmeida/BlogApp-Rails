class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.string :message

      t.timestamps
    end
  end
end
