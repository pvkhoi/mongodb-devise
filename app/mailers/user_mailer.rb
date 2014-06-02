class UserMailer < ActionMailer::Base
  default from: "info@misfit.com"

  def send_result_email(subject_email, user_name, user_email, result)
    to_email = "khoathai@misfit.com"

    @subject_email = subject_email
    @user_name =  user_name
    @user_email = user_email
    @result = result

    mail(:from => "info@misfit.com", :reply_to => "info@misfit.com", :to => to_email, :subject => subject_email)
    
  end
end
