class Friendship < ApplicationRecord
  belongs_to :this_user, class_name: 'User', foreign_key: 'this_user_id'
  belongs_to :other_user, class_name: 'User', foreign_key: 'other_user_id'
end
