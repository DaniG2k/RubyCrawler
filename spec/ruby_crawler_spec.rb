describe RubyCrawler do
  context 'configuration' do
    it '#configure allows configuration of the crawler via a block' do
      RubyCrawler.configure do |conf|
        conf.polite = true
        conf.start_urls = ['http://gocardless.com/']
        conf.include_patterns = [/gocardless.com/]
        conf.exclude_patterns = []
      end

      expect(RubyCrawler.configuration.polite?).to be_true
      expect(RubyCrawler.configuration.start_urls).to eq(['http://gocardless.com/'])
      expect(RubyCrawler.configuration.include_patterns).to eq([/gocardless.com/])
      expect(RubyCrawler.configuration.exclude_patterns).to eq([])
    end
  end
end
