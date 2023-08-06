class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @post = Post.new
    @user = User.find(params[:id])
    @links = []
    flickr = Flickr.new(ENV['flickr_key'], ENV['flickr_secret'])

    list = flickr.photos.getRecent
    # info = flickr.photos.getInfo

    id = list[2].id
    secret = list[2].secret
    info = flickr.photos.getInfo :photo_id => id, :secret => secret

    puts "info = #{info.title}"
    puts "dates = #{info.dates.taken}"

    link = flickr.photos.getInfo(:photo_id => id)
    puts "link = #{Flickr.url_b(link)}"

    @links << Flickr.url_b(link)


  end

  def add_friend
    # expect friend's index params[:target_friend_id]
    # check if friendship is already established

    puts "add friend request to #{params[:target_friend_id]}"

    established = false
    Friendship.all.each do |relation|
      if relation.this_user_id == @id && relation.other_user_id == params[:target_friend_id] || relation.this_user_id == params[:target_friend_id] && relation.other_user_id == @id
        established = true
      end
    end

    if !established
      @notification = Notification.new(user_id: params[:target_friend_id], sender: current_user.id)
      if @notification.save
        redirect_to root_url
      end

    end
  end

  def check_friendship?(friend_id)

    puts "FRIEND_ID = #{friend_id}"

    established = false

    @user = User.find(current_user.id)

    @user.friendships_in.each do |relation|
      if relation.this_user_id == @user.id
        if relation.other_user_id == friend_id
          established = true
        end
      elsif relation.other_user_id == @user.id
        if relation.this_user_id == @user.id
          established = true
        end
      end
    end

    @user.friendships_out.each do |relation|
      if relation.this_user_id == @user.id
        if relation.other_user_id == friend_id
          established = true
        end
      elsif relation.other_user_id == @user.id
        if relation.this_user_id == @user.id
          established = true
        end
      end
    end

    puts "FRIENDSHIP = #{established}"

    return established

  end
  helper_method :check_friendship?

  def accept_friend_request
    # expect sender_id

    puts "accept_friend_request"
    puts "sender_id = #{params[:sender_id]}"

    Notification.delete(params[:request_id])

    @friendship = Friendship.new(this_user_id: current_user.id, other_user_id: params[:sender_id])

    if @friendship.save
      redirect_to root_url
    end

  end

end
