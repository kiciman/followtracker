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


  def capital_markets
    
    @ticker = params[:ticker] ? params[:ticker] : ""
    @tickers = [@ticker] #["MMM","ABT","ABBV","ANF"]
    @formtype = params[:formtype] ? params[:formtype] : ""
    @ownership = params[:ownership] ? params[:ownership] : ""
    @count = "100"

    @agent = Account.current
    @filing_info = []    
    @tickers.each do |ticker|
      fulllink = "http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&type="+@formtype+"&CIK="+ticker+"&owner="+@ownership+"&count="+@count
      @filings_page = @agent.get(fulllink)    
      f_filing_links = @filings_page.search(".tableFile2/tr/td/a")
    
    
      f_filing_links.each do |x|

        f_temp = @agent.get("http://www.sec.gov/"+x[:href])
        f_tail = f_temp.search(".tableFile/tr/td/a")
        if f_tail[1].nil?
            next
        end
        f_doc = @agent.get("http://www.sec.gov/"+f_tail[1][:href])
      
        documentType = f_doc.at("documentType") ? f_doc.at("documentType").text : nil
        periodOfReport = f_doc.at("periodOfReporte") ? f_doc.at("periodOfReport").text : nil
        dateOfOriginalSubmission = f_doc.at("dateOfOriginalSubmission") ? f_doc.at("dateOfOriginalSubmission").text : nil
        notSubjectToSection16 = f_doc.at("notSubjectToSection16") ? f_doc.at("notSubjectToSection16").text : nil
        issuerCik = f_doc.at("issuerCik") ? f_doc.at("issuerCik").text : nil
        issuerName = f_doc.at("issuerName") ? f_doc.at("issuerName").text : nil
        issuerTradingSymbol = f_doc.at("issuerTradingSymbol") ? f_doc.at("issuerTradingSymbol").text : nil
        rptOwnerCik = f_doc.at("rptOwnerCik") ? f_doc.at("rptOwnerCik").text : nil
        rptOwnerName = f_doc.at("rptOwnerName") ? f_doc.at("rptOwnerName").text : nil
        officerTitle = f_doc.at("officerTitle") ? f_doc.at("officerTitle").text : nil
      
        isDirector = f_doc.at("officerTitle") ? f_doc.at("officerTitle").text : nil
        isOfficer = f_doc.at("officerTitle") ? f_doc.at("officerTitle").text : nil
        isTenPercentOwner = f_doc.at("officerTitle") ? f_doc.at("officerTitle").text : nil
        productType = f_doc.at("securityTitle") ? f_doc.at("securityTitle").text.gsub("\n","").gsub(" ","") : nil
        transactionDate = f_doc.at("transactionDate") ? f_doc.at("transactionDate").text.gsub("\n","").gsub(" ","") : nil
        transactionFormType = f_doc.at("nonDerivativeTable transactionFormType") ? f_doc.at("nonDerivativeTable transactionFormType").text : nil
        transactionCode = f_doc.at("nonDerivativeTable transactionCode") ? f_doc.at("nonDerivativeTable transactionCode").text : nil
        equitySwapInvolved = f_doc.at("nonDerivativeTable equitySwapInvolved") ? f_doc.at("nonDerivativeTable equitySwapInvolved").text : nil
        transactionShares = f_doc.at("nonDerivativeTable transactionShares") ? f_doc.at("nonDerivativeTable transactionShares").text.gsub("\n","").gsub(" ","") : nil
        transactionPricePerShare = f_doc.at("nonDerivativeTable transactionPricePerShare") ? f_doc.at("nonDerivativeTable transactionPricePerShare").text.gsub("\n","").gsub(" ","") : nil
        transactionAcquiredDisposedCode = f_doc.at("nonDerivativeTable transactionAcquiredDisposedCode") ? f_doc.at("nonDerivativeTable transactionAcquiredDisposedCode").text.gsub("\n","").gsub(" ","") : nil
        sharesOwnedFollowingTransaction = f_doc.at("nonDerivativeTable sharesOwnedFollowingTransaction") ? f_doc.at("nonDerivativeTable sharesOwnedFollowingTransaction").text.gsub("\n","").gsub(" ","")  : nil
        directOrIndirectOwnership = f_doc.at("nonDerivativeTable directOrIndirectOwnership") ? f_doc.at("nonDerivativeTable directOrIndirectOwnership").text.gsub("\n","").gsub(" ","") : nil


        derivsecurityTitle = f_doc.at("derivativeTable securityTitle value") ? f_doc.at("derivativeTable securityTitle value").text : nil
        derivconversionOrExercisePrice = f_doc.at("derivativeTable conversionOrExercisePrice value") ? f_doc.at("derivativeTable conversionOrExercisePrice value").text : nil
        derivtransactionDate = f_doc.at("derivativeTable transactionDate value") ? f_doc.at("derivativeTable transactionDate value").text  : nil
        derivtransactionFormTypeofficerTitle = f_doc.at("derivativeTable transactionFormType") ? f_doc.at("derivativeTable transactionFormType").text : nil
        derivtransactionCode = f_doc.at("derivativeTable transactionCode") ? f_doc.at("derivativeTable transactionCode").text : nil
        derivequitySwapInvolved = f_doc.at("derivativeTable equitySwapInvolved") ? f_doc.at("derivativeTable equitySwapInvolved").text : nil
        derivtransactionShares = f_doc.at("derivativeTable transactionShares value") ? f_doc.at("derivativeTable transactionShares value").text : nil
        derivtransactionPricePerShare = f_doc.at("derivativeTable transactionPricePerShare value") ? f_doc.at("derivativeTable transactionPricePerShare value").text : nil
        derivexerciseDate = f_doc.at("derivativeTable exerciseDate value") ? f_doc.at("derivativeTable exerciseDate value").text : nil
        derivexpirationDate = f_doc.at("derivativeTable expirationDate value") ? f_doc.at("derivativeTable expirationDate value").text : nil
        derivunderlyingSecurityTitle = f_doc.at("derivativeTable underlyingSecurityTitle value") ? f_doc.at("derivativeTable underlyingSecurityTitle value").text : nil
        derivunderlyingSecurityShares = f_doc.at("derivativeTable underlyingSecurityShares value") ? f_doc.at("derivativeTable underlyingSecurityShares value").text : nil
        derivsharesOwnedFollowingTransaction = f_doc.at("derivativeTable sharesOwnedFollowingTransaction value") ? f_doc.at("derivativeTable sharesOwnedFollowingTransaction value").text : nil
        derivdirectOrIndirectOwnership = f_doc.at("derivativeTable directOrIndirectOwnership value") ? f_doc.at("derivativeTable directOrIndirectOwnership value").text : nil

        footnotes = f_doc.at("footnotes") ? f_doc.at("footnotes").text : nil

      
      
        @filing_info << {
                        :documentType => documentType,
                        :periodOfReport => periodOfReport,
                        :dateOfOriginalSubmission => dateOfOriginalSubmission,
                        :notSubjectToSection16 => notSubjectToSection16,
                        :issuerCik => issuerCik,
                        :issuerName => issuerName,
                        :issuerTradingSymbol => issuerTradingSymbol,
                        :rptOwnerCik => rptOwnerCik,
                        :rptOwnerName => rptOwnerName,
                        :officerTitle => officerTitle,

                        :isDirector => isDirector,
                        :isOfficer => isOfficer,
                        :isTenPercentOwner => isTenPercentOwner,
                        :productType => productType,
                        :transactionDate => transactionDate,
                        :transactionFormType => transactionFormType,
                        :transactionCode => transactionCode,
                        :equitySwapInvolved => equitySwapInvolved,
                        :transactionShares => transactionShares,
                        :transactionPricePerShare => transactionPricePerShare,
                        :transactionAcquiredDisposedCode => transactionAcquiredDisposedCode,
                        :sharesOwnedFollowingTransaction => sharesOwnedFollowingTransaction,
                        :directOrIndirectOwnership => directOrIndirectOwnership,

                        :derivsecurityTitle => derivsecurityTitle,
                        :derivconversionOrExercisePrice => derivconversionOrExercisePrice,
                        :derivtransactionDate => derivtransactionDate,
                        :derivtransactionFormTypeofficerTitle => derivtransactionFormTypeofficerTitle,
                        :derivtransactionCode => derivtransactionCode,
                        :derivequitySwapInvolved => derivequitySwapInvolved,
                        :derivtransactionShares => derivtransactionShares,
                        :derivtransactionPricePerShare => derivtransactionPricePerShare,
                        :derivexerciseDate => derivexerciseDate,
                        :derivexpirationDate => derivexpirationDate,
                        :derivunderlyingSecurityTitle => derivunderlyingSecurityTitle,
                        :derivunderlyingSecurityShares => derivunderlyingSecurityShares,
                        :derivsharesOwnedFollowingTransaction => derivsharesOwnedFollowingTransaction,
                        :derivdirectOrIndirectOwnership => derivdirectOrIndirectOwnership,
                      
                        :footnotes => footnotes
        
                       }
                     end
      
      
    end

    @tickers = ["MMM","ABT","ABBV","ANF"]
    #,"ACE","ACN","ACT","ADBE","ADT","AMD","AES","AET","AFL","A","GAS","APD","ARG","AKAM","AA","ALXN","ATI","AGN","ALL","ALTR","MO","AMZN","AEE","AEP","AXP","AIG","AMT","AMP","ABC","AMGN","APH","APC","ADI","AON","APA","AIV","APOL","AAPL","AMAT","ADM","AIZ","T","ADSK","ADP","AN","AZO","AVB","AVY","AVP","BHI","BLL","BAC","BK","BCR","BAX","BBT","BEAM","BDX","BBBY","BMS","BRK.B","BBY","BIIB","BLK","HRB","BMC","BA","BWA","BXP","BSX","BMY","BRCM","BF.B","CHRW","CA","CVC","COG","CAM","CPB","COF","CAH","CFN","KMX","CCL","CAT","CBG","CBS","CELG","CNP","CTL","CERN","CF","SCHW","CHK","CVX","CMG","CB","CI","CINF","CTAS","CSCO","C","CTXS","CLF","CLX","CME","CMS","COH","KO","CCE","CTSH","CL","CMCSA","CMA","CSC","CAG","COP","CNX","ED","STZ","GLW","COST","COV","CCI","CSX","CMI","CVS","DHI","DHR","DRI","DVA","DF","DE","DELL","DLPH","DNR","XRAY","DVN","DO","DTV","DFS","DISCA","DG","DLTR","D","DOV","DOW","DPS","DTE","DD","DUK","DNB","ETFC","EMN","ETN","EBAY","ECL","EIX","EW","EA","EMC","EMR","ESV","ETR","EOG","EQT","EFX","EQR","EL","EXC","EXPE","EXPD","ESRX","XOM","FFIV","FDO","FAST","FDX","FIS","FITB","FHN","FSLR","FE","FISV","FLIR","FLS","FLR","FMC","FTI","F","FRX","FOSL","BEN","FCX","FTR","GME","GCI","GPS","GRMN","GD","GE","GIS","GPC","GNW","GILD","GS","GT","GOOG","GWW","HAL","HOG","HAR","HRS","HIG","HAS","HCP","HCN","HNZ","HP","HES","HPQ","HD","HON","HRL","HSP","HST","HCBK","HUM","HBAN","ITW","IR","TEG","INTC","ICE","IBM","IFF","IGT","IP","IPG","INTU","ISRG","IVZ","IRM","JBL","JEC","JDSU","JNJ","JCI","JOY","JPM","JNPR","K","KEY","KMB","KIM","KMI","KLAC","KSS","KRFT","KR","LTD","LLL","LH","LRCX","LM","LEG","LEN","LUK","LIFE","LLY","LNC","LLTC","LMT","L","LO","LOW","LSI","LYB","MTB","MAC","M","MRO","MPC","MAR","MMC","MAS","MA","MAT","MKC","MCD","MHFI","MCK","MJN","MWV","MDT","MRK","MET","MCHP","MU","MSFT","MOLX","TAP","MDLZ","MON","MNST","MCO","MS","MOS","MSI","MUR","MYL","NBR","NDAQ","NOV","NTAP","NFLX","NWL","NFX","NEM","NWSA","NEE","NKE","NI","NE","NBL","JWN","NSC","NTRS","NOC","NU","NRG","NUE","NVDA","NYX","ORLY","OXY","OMC","OKE","ORCL","OI","PCAR","PLL","PH","PDCO","PAYX","BTU","JCP","PNR","PBCT","POM","PEP","PKI","PRGO","PETM","PFE","PCG","PM","PSX","PNW","PXD","PBI","PCL","PNC","RL","PPG","PPL","PX","PCP","PCLN","PFG","PG","PGR","PLD","PRU","PEG","PSA","PHM","PVH","QEP","PWR","QCOM","DGX","RRC","RTN","RHT","REGN","RF","RSG","RAI","RHI","ROK","COL","ROP","ROST","RDC","R","SWY","SAI","CRM","SNDK","SCG","SLB","SNI","STX","SEE","SRE","SHW","SIAL","SPG","SLM","SJM","SNA","SO","LUV","SWN","SE","S","STJ","SWK","SPLS","SBUX","HOT","STT","SRCL","SYK","STI","SYMC","SYY","TROW","TGT","TEL","TE","THC","TDC","TER","TSO","TXN","TXT","HSY","TRV","TMO","TIF","TWX","TWC","TJX","TMK","TSS","TRIP","TSN","TYC","USB","UNP","UNH","UPS","X","UTX","UNM","URBN","VFC","VLO","VAR","VTR","VRSN","VZ","VIAB","V","VNO","VMC","WMT","WAG","DIS","WPO","WM","WAT","WLP","WFC","WDC","WU","WY","WHR","WFM","WMB","WIN","WEC","WPX","WYN","WYNN","XEL","XRX","XLNX","XL","XYL","YHOO","YUM","ZMH","ZION"]
    
    
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
