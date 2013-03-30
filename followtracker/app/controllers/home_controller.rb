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
  
  def twitter_data
    if params[:screen_name]
      @sname = params[:screen_name]
    else
      @sname = "SunnyBump"
    end
    @followers = grab_followers(@sname)
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
  
  
  def pinterest_data
    @agent = Account.current
    page_num = 1
    pop_pinners = []
    #REPINLY LINKS:for each paginated piece of the list of top pinners we're going to grab every repinly page link
    puts "Entering the REPINLY LINKS"
    while page_num < 101
      pagelink = "http://www.repinly.com/popular_pinners.aspx?p=#{page_num}&by=follr"
      begin
        page = @agent.get(pagelink)
      rescue Mechanize::ResponseCodeError => e
        page_num = page_num + 1
        next
      end  
      tl = page.search("div/.pp_bolns/a") ? page.search("div/.pp_bolns/a") : nil
      if tl.nil?
        next
      end
      tl.each do |s|
        puts s[:href]
        pop_pinners << s[:href]
      end
      page_num = page_num + 1
      sleep(1)
    end
    #PINTEREST LINKS: for each of the top pinners page we're going to grab every pinterst page link
    pop_pinners_links = []
    puts "Entering the PINTEREST LINKS"
    pop_pinners.each do |pp|
      if pp.nil?
        next
      else
        pagelink = "http://www.repinly.com" + pp
      end
      begin
        page = @agent.get(pagelink)
      rescue Mechanize::ResponseCodeError => e
        next
      end  
      puts page.at("#u_lnk")[:href]      
      pop_pinners_links << page.at("#u_lnk")[:href]
      sleep(1)
    end
    #FACEBOOK LINKS: for every pinterest page link, we're going to check for a facebook link and keep it if there is one.
    puts "Entering the FACEBOOK LINKS"
    pop_pinners_facebook = []
    pop_pinners_links.each do |ppl|
      begin
        page = @agent.get(ppl)
      rescue Mechanize::ResponseCodeError => e
        next
      end
      sleep(1)
      fb_id = page.at(".facebook") ? page.at(".facebook")[:href].gsub("http://facebook.com/profile.php?id=", "") : nil
      fers_count = page.search("#ContextBar/div.FixedContainer/ul.follow/li/a").children()[1].text
      fing_count = page.search("#ContextBar/div.FixedContainer/ul.follow/li/a").children()[4].text
      puts fb_id
      if fb_id.nil?
        next
      else
        pop_pinners_facebook << {:fb_id => fb_id,:pin_link => ppl, :fers_count => fers_count, :fing_count => fing_count}
        
      end
    end
    
    @pop_fb = pop_pinners_facebook
  end
  

  private
  
  def grab_followers(screen_name)
    raw_followers = Twitter.follower_ids(screen_name)
    sliced_followers = raw_followers.each_slice(100).to_a
    temp = []
    followers = []
    sliced_followers.each do |sf|
      temp = sf.collect {|c| c}
      user_data = Twitter.users(temp, :method => :get, :include_entities => false)
      user_data.each do |ud|
        followers << {:screen_name => ud[:screen_name], :followers_count => ud[:followers_count]}
      end
    end
    return followers.sort_by{|a| a[:followers_count]}.reverse
  end
  
  
  def setup_company
    @company_link = "379681"
  end
  
end
