class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :set_current_account

  def set_current_account
    
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
    page = @agent.get('https://www.linkedin.com/uas/login?goback=&trk=hb_signin')
    login_form = @agent.page.form("login")
    login_form.session_key = "kiciman@gmail.com"
    login_form.session_password = "linkedin.fish"
    login_form.submit
    
    Account.current = @agent
  end
end
