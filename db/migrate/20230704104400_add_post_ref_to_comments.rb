class AddPostRefToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :post, foreign_key: true

    add_column :comments, :prev, :integer
    add_column :comments, :next, :integer
  end
end
