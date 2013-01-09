class HomeController < ApplicationController
  before_filter :setup_profile
  
  def index
    
    main_profile = Profile.create(:link => @profile_link)
    @out = main_profile.get_related_view
    
  end
  
  private
  
  
  def setup_profile
    @profile_link = "http://www.linkedin.com/profile/view?noScript=1&goback=%2Enpv_8782370_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_1_*1_*1_*1_*1%2Enpv_348975_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_*1_1_*1_*1_*1_*1%2Efps_PBCK_joey+hawilo_*1_*1_*1_*1_*1_*1_*2_*1_Y_*1_*1_*1_false_1_R_*1_*51_*1_*51_true_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2&id=8782370&srchid=34d08f28-6380-48b5-8d08-5c15944fd205-0&pvs=ps&srchindex=1&locale=en_US&authToken=E3m8&trk=pp_profile_name_link&srchtotal=1&authType=NAME_SEARCH"
  end


end
