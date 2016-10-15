describe RubyCrawler do
  context 'configuration' do
    it '#configure allows configuration of the crawler via a block' do
      RubyCrawler.configure do |conf|
        conf.polite = true
        conf.start_urls = ['http://mywebsite.com/']
        conf.include_patterns = [/mywebsite\.com/]
        conf.exclude_patterns = []
      end

      expect(RubyCrawler.configuration.polite?).to be true
      expect(RubyCrawler.configuration.start_urls).to eq(['http://mywebsite.com/'])
      expect(RubyCrawler.configuration.include_patterns).to eq([/mywebsite\.com/])
      expect(RubyCrawler.configuration.exclude_patterns).to eq([])
    end
  end

  context 'spider' do
    before :all do
      RubyCrawler.configure do |conf|
        conf.polite = true
        conf.start_urls = ['https://gocardless.com/']
        conf.include_patterns = [/https:\/\/gocardless\.com/]
        conf.exclude_patterns = []
      end
    end

    it 'crawls a series of urls given a start url and include pattern' do
      stored = %w(https://gocardless.com/
                  https://gocardless.com/features/
                  https://gocardless.com/pricing/
                  https://gocardless.com/accountants/
                  https://gocardless.com/charities/
                  https://gocardless.com/agencies/
                  https://gocardless.com/education/
                  https://gocardless.com/finance/
                  https://gocardless.com/local-government/
                  https://gocardless.com/saas/
                  https://gocardless.com/telcos/
                  https://gocardless.com/utilities/)

      RubyCrawler.crawl

      expect(RubyCrawler.stored).to eq(stored)
      expect(RubyCrawler.stored.size).to eq(12)
    end

    it "#parse_robots_txt takes into account a website's robots.txt file" do
      expected = [/\/connect\//,
        /\/pay\//,
        /\/merchants\//,
        /\/users\//,
        /\/oauth\//,
        /\/health_check\//,
        /\/api\//]
      RubyCrawler::Spider.new.parse_robots_txt

      expect(RubyCrawler.configuration.exclude_patterns).to eq(expected)
    end

  end
end
