describe RubyCrawler::Spider do

  it '#is_relatve? returns true on relative urls' do
    spider = RubyCrawler::Spider.new

    expect(spider.is_relative?('/some-interesting-page')).to be true
  end

  it '#is_relatve? returns false on absolute urls' do
    spider = RubyCrawler::Spider.new

    expect(spider.is_relative?('www.asahi.com/some-interesting-page')).to be false
  end

  context 'matches' do
    before :all do
      RubyCrawler.configure do |conf|
        conf.polite = true
        conf.start_urls = ['http://mywebsite.com/']
        conf.include_patterns = [/mywebsite\.com/]
        conf.exclude_patterns = [/my\-page/]
      end
    end

    it '#matches_include_patterns? returns true when there is a match' do
      spider = RubyCrawler::Spider.new
      mypage = 'mywebsite.com/my-page'

      expect(spider.matches_include_patterns?(mypage)).to be true
    end

    it '#matches_include_patterns? returns false when there is not a match' do
      spider = RubyCrawler::Spider.new
      mypage = 'asahi.com/my-page'

      expect(spider.matches_include_patterns?(mypage)).to be false
    end

    it '#matches_exclude_patterns? returns true when there is a match' do
      spider = RubyCrawler::Spider.new
      mypage = 'mywebsite.com/my-page'

      expect(spider.matches_exclude_patterns?(mypage)).to be true
    end

    it '#matches_exclude_patterns? returns false when there is not a match' do
      spider = RubyCrawler::Spider.new
      mypage = 'asahi.com/'

      expect(spider.matches_exclude_patterns?(mypage)).to be false
    end

  end

  it "extracts a page's static assets" do
    RubyCrawler.reset
    RubyCrawler.configure do |conf|
      conf.start_urls = ['https://gocardless.com/']
      conf.include_patterns = [/https:\/\/gocardless\.com$/]
    end

    spider = RubyCrawler.crawl
    assets = {"https://gocardless.com/"=>
              {:css=>["https://gocardless.com/bundle/main-0d7cb6738d59e4c22838.css"],
               :images=>
                ["https://gocardless.com/images/logos/pro-logos@2x.png",
                 "https://gocardless.com/images/logos/funding-circle-logo-white.png",
                 "https://gocardless.com/images/flags/GB-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/AU-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/BE-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/BE-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/BR-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/CA-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/DE-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/ES-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/EU-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/FR-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/IE-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/NL-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/NZ-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/SE-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/US-flag-icon@2x.png",
                 "https://gocardless.com/images/flags/GB-flag-icon@2x.png"],
               :javascript=>
                ["//www.googletagmanager.com/gtm.js?id=GTM-PRFKNC",
                 "/bundle/main-0d7cb6738d59e4c22838.js"]}}
    expect(RubyCrawler.assets).to eq(assets)
  end
end
