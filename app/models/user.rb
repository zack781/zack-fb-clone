class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[facebook]

  has_many :posts
  # belongs_to :friends, class_name: 'User', foreign_key: 'friend_id'
  # has_many :friends, :foreign_key => "friend_id", class_name: "User"

  # has_and_belongs_to_many :friends,
  #    class_name: "User",
  #    foreign_key: "this_user_id",
  #    association_foreign_key: "other_user_id"

  # has_many :friendships, :foreign_key => "this_user_id", class_name: "Friendship"
  # has_many :friendships, :foreign_key => "other_user_id", class_name: "Friendship"

  # has_and_belongs_to_many :friends,
  #    class_name: "User",
  #    foreign_key: "this_user_id",
  #    association_foreign_key: "other_user_id"

  has_many :friendships_out, :foreign_key => "this_user_id", class_name: "Friendship"
  has_many :friendships_in, :foreign_key => "other_user_id", class_name: "Friendship"

  has_many :notifications

  has_many :posts
end
