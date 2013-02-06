class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_account

  def set_current_account
    
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
    
    #--For crawling and logging into linkedin--
    
    #page = @agent.get('https://www.linkedin.com/uas/login?goback=&trk=hb_signin')
    #login_form = @agent.page.form("login")
    #login_form.session_key = "kiciman@gmail.com"
    #login_form.session_password = "linkedin.fish"
    #login_form.submit
    
    Account.current = @agent
    
    Twitter.configure do |config|
      config.consumer_key = "MDrR9BxYXS4miBT8NbMg"
      config.consumer_secret = "9ns7T3JvcuwcslUeBJ6LigM973gd0VPeUsuUKJqSlc"
      config.oauth_token = "883288452-5dyhFvhV7ill8uPOOCwfNvCnis0i6qjkFvqvqKdm"
      config.oauth_token_secret = "bSaZQDjQA9TvkDuIiAQrDajiZ9ptcgwoIxstXsPrY"
    end
    

  end
end
