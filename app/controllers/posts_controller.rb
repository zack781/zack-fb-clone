class PostsController < ApplicationController
  before_action :require_login

  def index
    # This is the Timeline
    # @posts = Post.all
    @posts = Post.order(created_at: :desc)
  end

  def create

    puts "CREATING NEW POST"

    #@post = Post.new(user_id: current_user.id, content: params[:post_content])
    puts "user_id = #{post_params[:user_id]}"
    puts "content = #{post_params[:post_content]}"
    puts "avatar = #{post_params[:avatar]}"

    @post = Post.new(post_params)

    if @post.save

      #update = Post.find(@post.id)

      #puts "FILE UPLOADED = #{params[:myfile]}"

      #update.avatar.attach(params[:myfile])
      #update.save
      redirect_to root_url
    end
  end

  def comment
    # get request for comment html
  end

  def recursive_comment(next_comments = [], res = [], layer = 0)
    # next_comments.to_s
    if next_comments.nil? || next_comments.length <= 0
      puts "RES = #{res} ------------"
      return res
    else
      next_comments.each do |comment|
        res << [comment, layer]
        puts "next COMMENTS = #{Comment.find(comment).next_comments}"
        recursive_comment(Comment.find(comment).next_comments, res, layer+4)
    end
      return res
    end
  end
  helper_method :recursive_comment

  def add_comment
    # parameters:
    # - content of the comment
    # - previous comment
    # - post_id

    puts "add new COMMENT ----!"

    @comment = Comment.new(post_id: params[:post_id], prev: params[:cmt_prev], content: params[:cmt_content])

    puts "post_id = #{params[:post_id]}"
    puts "prev_comment = #{params[:cmt_prev]}"

    if @comment.save
        puts "Add previous ------------------!!"

        puts "cmt_prev = #{params[:cmt_prev].nil?}"
        if (!params[:cmt_prev].nil? && !params["cmt_prev"].empty?)
          item = Comment.find(params[:cmt_prev])
          item.next_comments << @comment.id
          item.save
        end

    end

    redirect_to root_url
    # redirect_back(fallback_location: root_path)
  end

  def add_like
    @post = Post.find(params[:post_id])

    if @post.likes.nil?
      @post.likes = 1
      @post.save
    else
      @post.likes = @post.likes + 1
      @post.save
    end

    redirect_to root_url
  end

  private
  def require_login
    puts "signed in = #{user_signed_in?}"
    if !user_signed_in?
      redirect_to new_user_session_url
    end
  end

  def post_params
    params.require(:post).permit(:content, :avatar, :user_id)
  end

end
