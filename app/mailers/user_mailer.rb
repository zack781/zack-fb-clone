class UserMailer < ApplicationMailer
  default from: 'thean781@gmail.com'

  def welcome_email
    puts "USER = #{params[:user]}"

    @user = params[:user]
    @url = 'http://localhost:3000/users/new'
    mail(to: @user.email, subject: "Welcome to Zack's Facebook")
  end
end
