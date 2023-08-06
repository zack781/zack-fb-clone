class AddUsersRefToFriends < ActiveRecord::Migration[7.0]
  def change
    add_reference :friendships, :this_user, foreign_key: {to_table: :users}
    add_reference :friendships, :other_user, foreign_key: {to_table: :users}
  end
end
