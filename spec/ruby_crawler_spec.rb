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
    it 'crawls a series of urls given a start url and include pattern' do
      start_list = ['https://gocardless.com/']
      RubyCrawler.configure do |conf|
        conf.polite = true
        conf.start_urls = start_list
        conf.include_patterns = [/https:\/\/gocardless\.com/]
        conf.exclude_patterns = []
      end

      RubyCrawler.crawl

      expect(RubyCrawler::Spider.stored).to eq(start_list)
    end
  end
end
