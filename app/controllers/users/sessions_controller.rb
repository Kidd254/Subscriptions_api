class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!
  include RackSessionFix

  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  # Handle the response after destroying a session (logout)
  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end

  private

  # Strong parameters for user login
  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
end
