class AddSenderToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :sender, :integer
  end
end
