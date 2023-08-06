class AddNextCommentsArrayToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :next_comments, :integer, array: true, default: '{}'
    add_column :comments, :prev_comments, :integer, array: true, default: '{}'
  end
end
