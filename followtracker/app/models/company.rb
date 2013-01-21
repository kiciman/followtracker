class Company < ActiveRecord::Base
  has_many :employees
  attr_accessible :link, :name
  
  def get_employees
    @agent = Account.current  
    fulllink = "http://www.linkedin.com/search/fpsearch?facet_SE=2&facet_SE=1&facet_SE=5&facet_SE=4&facet_SE=3&companyId="+ link + "&sortCriteria=R&keepFacets=&facet_CC=" + link
    page = @agent.get(fulllink)
    
    if page.at("ol#result-set").first
      page.at("ol#result-set").search("li.vcard").each do |vcard|
        v={}
        v[:name]=vcard.at('h2/a').text.gsub("\n", "").strip!
        v[:title]= vcard.at('dd.title').text    
        v[:link]= "http://www.linkedin.com" + vcard.at('h2/a')[:href]
        self.employees << Employee.new(:name => v[:name], :title => v[:title], :link => v[:link])
        
      end
    end  
    
    @agent.cookie_jar.clear!  

    return self.employees
    
  end
  
end
