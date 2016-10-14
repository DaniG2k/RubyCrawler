describe RubyCrawler::Spider do

  it '#is_relatve? returns true on relative urls' do
    spider = RubyCrawler::Spider.new

    expect(spider.is_relative?('/some-interesting-page')).to be true
  end

  it '#is_relatve? returns false on absolute urls' do
    spider = RubyCrawler::Spider.new

    expect(spider.is_relative?('www.asahi.com/some-interesting-page')).to be false
  end

  it '#matches_include_patterns? returns true when there is a match' do
    RubyCrawler.configure do |conf|
      conf.polite = true
      conf.start_urls = ['http://mywebsite.com/']
      conf.include_patterns = [/mywebsite\.com/]
      conf.exclude_patterns = []
    end
    spider = RubyCrawler::Spider.new
    mypage = 'mywebsite.com/my-page'

    expect(spider.matches_include_patterns?(mypage)).to be true
  end

  it '#matches_include_patterns? returns false when there is not a match' do
    RubyCrawler.configure do |conf|
      conf.polite = true
      conf.start_urls = ['http://mywebsite.com/']
      conf.include_patterns = [/mywebsite\.com/]
      conf.exclude_patterns = []
    end
    spider = RubyCrawler::Spider.new
    mypage = 'asahi.com/my-page'

    expect(spider.matches_include_patterns?(mypage)).to be false
  end
end
