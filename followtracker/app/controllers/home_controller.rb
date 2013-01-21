class HomeController < ApplicationController
  before_filter :setup_company
  
  def index
    
    #main_profile = Profile.create(:link => @profile_link)
    #@out = main_profile.get_related_view
    
    main_company = Company.new(:link => @company_link, :name => "Monsanto")
    #gather the employees of the main_company
    @emps = main_company.get_employees
    
    #gather the people_also_viewed section for each employee
    all_viewed = []
    @related_cos = []
    @emps.each do |e|
      all_viewed << e.get_related
    end
    
    @related_cos = all_viewed.flatten(1).reject{|x| x == ""}.group_by{|i| i.lowercase.gsub(".", "").gsub(",", "")}.map{|h,j|[h,j.count]}.sort_by{|a| -a[1]}
    
  end
  
  private
  
  
  def setup_company
    @company_link = "379681"
  end
  
end
