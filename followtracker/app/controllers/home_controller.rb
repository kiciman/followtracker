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
  
  def refinery_data
    
    pickupat = params[:pickupat] ? params[:pickupat].to_i : 0
    @refineries = RefineryData.all
    
    if params[:getdata].to_i == 1
      @agent = Account.current
      fulllink = "http://abarrelfull.wikidot.com/global-refineries"
      page = @agent.get(fulllink)
    
      continents = ["african-refineries", "asian-refineries", "australasian-refineries", "central-asian-and-russian-refineries", "european-refineries", "middle-eastern-refineries", "north-american-refineries", "us-refineries", "south-and-central-american-refineries"]

      count = 0
      continents.each do |c|
        p = @agent.get("http://abarrelfull.wikidot.com/" + c)
        temp = p.search("#page-content/ul/li")
        temp.each do |x|
          count = count + 1
          next if count < pickupat
          next if x.at("a").nil?
          begin
            refinery_page = @agent.get(x.at("a")[:href])
          rescue Mechanize::ResponseCodeError => e
            next
          end
                
          sleep 0.2
          begin 
            lis = refinery_page.search("#page-content/ul/li")
          rescue Exception => e
            next
          end
        
          r_name = refinery_page.at("#page-title") ? refinery_page.at("#page-title").text.gsub("\n", "").strip : nil
          r_company = refinery_page.at('//h3[.="Summary Information"]') ? refinery_page.at('//h3[.="Summary Information"]').next ? refinery_page.at('//h3[.="Summary Information"]').next.next ? refinery_page.at('//h3[.="Summary Information"]').next.next.search("li")[0] ? refinery_page.at('//h3[.="Summary Information"]').next.next.search("li")[0].text.split(": ")[1] : nil : nil : nil : nil
          next if r_company.nil?
          r_city = refinery_page.at('//h3[.="Summary Information"]') ? refinery_page.at('//h3[.="Summary Information"]').next ? refinery_page.at('//h3[.="Summary Information"]').next.next ? refinery_page.at('//h3[.="Summary Information"]').next.next.search("li")[2] ? refinery_page.at('//h3[.="Summary Information"]').next.next.search("li")[2].text.split(": ")[1] : nil : nil : nil : nil
          r_capacity = refinery_page.at('//h3[.="Summary Information"]') ? refinery_page.at('//h3[.="Summary Information"]').next ? refinery_page.at('//h3[.="Summary Information"]').next.next ? refinery_page.at('//h3[.="Summary Information"]').next.next.search("li")[3] ? refinery_page.at('//h3[.="Summary Information"]').next.next.search("li")[3].text.split("& ")[1] : nil : nil : nil : nil
          r_supply = refinery_page.at('//h3[.="Crude Supply"]') ? refinery_page.at('//h3[.="Crude Supply"]').next ? refinery_page.at('//h3[.="Crude Supply"]').next.next ? refinery_page.at('//h3[.="Crude Supply"]').next.next.children ? refinery_page.at('//h3[.="Crude Supply"]').next.next.children.text : nil : nil : nil : nil
          r_country = c
        

        
          puts r_name
          puts count
        
          @refineries << RefineryData.create(:name => r_name, :country => r_country, :company => r_company, :city => r_city, :capacity => r_capacity, :supply => r_supply)

        end
      end
    end
  end
  
  
  
  private
  
  
  def setup_company
    @company_link = "379681"
  end
  
end
