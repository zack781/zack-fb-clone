class AddUserRefToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :user, index: true
    add_foreign_key :notifications, :users
  end
end
