class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google
		@user = User.find_for_google_oauth(request.env["omniauth.auth"])
	end
end