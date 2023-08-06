# frozen_string_literal: true

require 'net/smtp'
require 'google/apis/gmail_v1'
require 'google/api_client/client_secrets'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'rmail'

class Users::RegistrationsController < Devise::RegistrationsController
  Gmail = Google::Apis::GmailV1
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

  def well_known_path_for(file)
    if OS.windows?
      dir = ENV.fetch('HOME'){ ENV['APPDATA'] }
      File.join(dir, 'google', file)
    else
      File.join(ENV['HOME'], '.config', 'google', file)
    end
  end

  def token_store_path
    return ENV['GOOGLE_CREDENTIAL_STORE'] if ENV.has_key?('GOOGLE_CREDENTIAL_STORE')
    return well_known_path_for('credentials.yaml')
  end

  # POST /resource
  def create
    super
    FileUtils.mkdir_p(File.dirname(token_store_path))

    puts "REGISTRATION __________"

    puts "ENV['HOME'] = #{ENV['HOME']}"

    puts "flash message = #{resource}"

    scope = 'https://www.googleapis.com/auth/gmail.send'

    client_id = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])

    client_id = Google::Auth::ClientId.from_file(ENV['GOOGLE_APPLICATION_CREDENTIALS'])

    puts "GOOGLE client ID = #{ENV['GOOGLE_CLIENT_ID']}"
    puts "GOOGLE client SECRET = #{ENV['GOOGLE_CLIENT_SECRET']}"

    puts "CLIENT ID = #{client_id}"


    puts "TOKEN_STORE_PATH = #{token_store_path}"

    token_store = Google::Auth::Stores::FileTokenStore.new(:file => token_store_path)

    puts "TOKEN_STORE = #{token_store}"

    authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

    user_id = 'default'

    puts "USER_ID = #{user_id}"

    credentials = authorizer.get_credentials(user_id)


    if credentials.nil?
      # Acquire authorization code
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts "URL = #{url}"
      # code = <Replace with you code here>
      credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: OOB_URI)


    puts "email = #{resource.email}"

    puts "credentials = #{credentials}"

    puts "credentials nil = #{credentials.nil?}"

    gmail = Gmail::GmailService.new
    gmail.authorization = credentials

    message = RMail::Message.new
    message.header['To'] = resource.email
    message.header['From'] = 'thean781@gmail.com'
    message.header['Subject'] = 'Zack FB Confirmation'
    message.body = 'Hello World'

    gmail.send_user_message('me',
                            upload_source: StringIO.new(message.to_s),
                            content_type: 'message/rfc822')

  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
