class AddFriendRefToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :friends, foreign_key: {to_table: :users}
  end
end
