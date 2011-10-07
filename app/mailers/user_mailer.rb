class UserMailer < ActionMailer::Base
  default from: "dosimetry@coloradocyberknife.com"
  
  def status_email(plan, short_message, long_message)
    @plan = plan
    email_with_name = "Dosimetry"
    @short_message = short_message
    @long_message = long_message
    mail(:to => @plan.maillist, :subject => "#{@plan.lastname}, #{@plan.firstname} (#{@plan.target}): #{@short_message}")
  end
end
