class Profile < ActiveRecord::Base
  belongs_to :company
  has_many :related_views
  
  attr_accessible :company, :link, :name, :title
  
  def get_related_view
    @agent = Account.current    
    
    page = @agent.get(link)
    also_viewed=[]
        
    if page.at(".browsemap").first
      page.at(".browsemap").at("ul").search("li").each do |visitor|
        v={}

        v[:name]=visitor.at('strong/a').text
        v[:jobtitle]= visitor.at('.headline').text.split(" at ")[0]      
        v[:company]= visitor.at('.headline').text.split(" at ")[1]      
        v[:link]=visitor.at('a')["href"]
        also_viewed<<v
      end
    end    

    return also_viewed
    
  end
  
end
