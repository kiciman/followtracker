class Employee < ActiveRecord::Base
  belongs_to :company
  has_many :related_views
  attr_accessible :companyname, :link, :name, :title
  
  
  def get_related
    @agent = Account.current    
    
    page = @agent.get(link + "&noScript=1")
    also_viewed=[]
        
    if page.at(".browsemap")
      page.at(".browsemap").at("ul").search("li").each do |rec|
        
        temp_link = rec.at('a')["href"] + "&noScript=1"
        temp_page = @agent.get(temp_link)
        if temp_page.at(".masthead/p")
          temp_masthead = temp_page.at(".masthead/p").text
          also_viewed << temp_masthead.split(" at ")[1]        
        end
        
        #v={}
        #v[:name]=rec.at('strong/a').text
        #v[:link]=rec.at('a')["href"]
        #v[:title]= temp_masthead.split(" at ")[0]      
        #v[:companyname]= temp_masthead.split(" at ")[1]      
      end
    end
    
      

    return also_viewed
    
  end
end
