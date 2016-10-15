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

    it "#parse_robots_txt can parse more complex robots.txt files" do
      RubyCrawler.configure do |conf|
        conf.polite = true
        conf.start_urls = ['http://bbc.co.uk']
        conf.include_patterns = [/bbc\.co\.uk/]
        conf.exclude_patterns = []
      end
      expected = [/\/_programmes/, /\/606\//, /\/aboutthebbc\/insidethebbc\/search/, /\/academy\/chinese-trad\/search/, /\/afrique\/search/, /\/apps\/cbbc/, /\/apps\/flash/, /\/apps\/ide/, /\/apps\/ids/, /\/apps\/ifl/, /\/apps\/nr/, /\/apps\/query/, /\/apps\/t/, /\/arabic\/search/, /\/arts\/yourpaintings\/artdetective\//, /\/arts\/yourpaintings\/feedback\/sent\//, /\/arts\/yourpaintings\/images\/guidedtours\//, /\/arts\/yourpaintings\/newsletter\/error\//, /\/arts\/yourpaintings\/newsletter\/success\//, /\/arts\/yourpaintings\/newsletter\/unsubscribe\//, /\/arts\/yourpaintings\/paintings\/search/, /\/azeri\/search/, /\/bbctrust\/search/, /\/bengali\/search/, /\/burmese\/search/, /\/cbbc\/find/, /\/cbbc\/newsroundfind/, /\/cbbc\/search/, /\/cbeebies\/search/, /\/cbeebies\/searchresults/, /\/cgi-bin/, /\/cgi-perl/, /\/cgi-perlx/, /\/cgi-store/, /\/corporate2\/bbctrust\/search/, /\/corporate2\/insidethebbc\/search/, /\/corporate2\/mediacentre\/proginfo\/search/, /\/corporate2\/mediacentre\/search/, /\/corporate2\/safety\/search/, /\/cwynion\//, /\/democracylive\/index\/search/, /\/eastenders\/updates\//, /\/education\/bitesize/, /\/education\/dev/, /\/education\/images/, /\/education\/nav/, /\/education\/navigation/, /\/education\/ximages/, /\/eoltools\//, /\/films\/gateways/, /\/food\/binder\//, /\/food\/recipes\/search*?*/, /\/frameworks\/fig\//, /\/furniture/, /\/gahuza\/search/, /\/h2g2\/servers\/narthur8/, /\/hausa\/search/, /\/hindi\/search/, /\/history\/domesday\/search/, /\/includes\//, /\/indonesia\/search/, /\/iplayer\/_proxy_/, /\/iplayer\/bigscreen\//, /\/iplayer\/cbbc\/episodes\//, /\/iplayer\/cbbc\/search/, /\/iplayer\/cbeebies\/episodes\//, /\/iplayer\/cbeebies\/search/, /\/iplayer\/cy\//, /\/iplayer\/gd\//, /\/iplayer\/pagecomponents\//, /\/iplayer\/playlist\//, /\/iplayer\/search/, /\/iplayer\/usercomponents\//, /\/kyrgyz\/search/, /\/learningzone\/clips\/search/, /\/mediacentre\/proginfo\/search/, /\/mediacentre\/search/, /\/mediaselector/, /\/messageboards\//, /\/mundo\/search/, /\/music\/releases\//, /\/nav\//, /\/navigation/, /\/nepali\/search/, /\/news\/uk-30888157/, /\/news\/uk-england-suffolk-20780472/, /\/partners\//, /\/pashto\/search/, /\/persian\/search/, /\/portuguese\/search/, /\/pressoffice\/plots\//, /\/print\//, /\/programmes\/articles\/1jJwRxT3X9s0QlBsCMhvv7D\/2013-fundraising-packs/, /\/programmes\/articles\/1nSkm7VR3fypxqB16dDtVwk\/how-to-get-sponsored/, /\/programmes\/articles\/1RjY5ZcmdvRKPvbS662Jv9C\/welsh-downloads-2013/, /\/programmes\/articles\/25h23bXRXFlGdVQ86hNFVkT\/secondary-schools-fundraising/, /\/programmes\/articles\/2S6fTlHnqvdHGswDJ9yLs6r\/early-years-fundraising/, /\/programmes\/articles\/35Cb1BsKBWZNfhVDp07K1y1\/students/, /\/programmes\/articles\/4P9FhkRwqvYHVXmX6c13Bfd\/downloads-page/, /\/programmes\/articles\/4qd5GpykkdkGZtYrRR5h073\/ideas-and-downloads/, /\/programmes\/articles\/4zNrFLZXqfGcBFRHzLnkxqw\/primary-schools-fundraising/, /\/programmes\/articles\/4zplPWW97l5Yk1BhTY4p3rz\/tell-us-what-youre-doing/, /\/programmes\/articles\/5kgXgM40wp1JM9lSB1f18Yd\/fundraising/, /\/programmes\/articles\/91J9cY9hzMLrsCmM7tX113\/cerries-jump-up-and-dance-competition/, /\/programmes\/articles\/psvxkB6QDMK63pgHmP5RJF\/who-you-help/, /\/programmes\/articles\/RRWbSk1mCZngypVngyZYJ0\/get-your-money-to-us/, /\/programmes\/articles\/v8qTSbm89w6DnfgxFL5GBk\/fundraising-at-school/, /\/programmes\/articles\/ZY66x6RD4jg5kqv8t7vn56\/lets-go-shopping/, /\/programmes\/b008dk4b/, /\/programmes\/profiles\/1YyY0F36ppV3DmnSkNTrRxZ\/downloads-for-primary-schools/, /\/programmes\/profiles\/2dgMD54k88Lz77lYcy7mRhc\/secondary-school-fundraising-ideas/, /\/programmes\/profiles\/2x87wV7KW01sgY0dl7qBnT6\/recipes/, /\/programmes\/profiles\/33x1x5jLwh1MbhpFXhlxq37\/posters-stickers-and-games/, /\/programmes\/profiles\/3yvcq7cxMmNLCzSzDCWsPyM\/primary-school-fundraising-ideas/, /\/programmes\/profiles\/49qkZq0Pmmh4flWgYSPhgPj\/fundraising-ideas-at-work/, /\/programmes\/profiles\/49QnjFZ5T6f6sdQY399HNzf\/primary-teacher-resources/, /\/programmes\/profiles\/4KFFdqWQZ9lSPl1qHnRPbNV\/be-a-hero/, /\/programmes\/profiles\/4yn6kWyMJZLgPZj4100SSkh\/early-years-teacher-resources/, /\/programmes\/profiles\/54k8kVKM9gTzVL4zvDJ1BzN\/secondary-teacher-resources/, /\/programmes\/profiles\/581RcyV6nP3Jtxk9Vcy9Hnq\/downloads-for-early-years/, /\/programmes\/profiles\/5wdxQwnlLHJNY9y2Nxm1RkQ\/fundraising-ideas/, /\/programmes\/profiles\/cGJ1RZ5pHG0Jl65YSN0YYc\/downloads-for-secondary-schools/, /\/programmes\/profiles\/qWq8hB1135cdgj2cqNXyWB\/early-years-fundraising-ideas/, /\/radio\/aod\//, /\/radio\/player/, /\/russian\/search/, /\/safety\/search/, /\/schools\/typing\/about\//, /\/schools\/typing\/flash\//, /\/schools\/typing\/generic\//, /\/schools\/typing\/levels\//, /\/search/, /\/sinhala\/search/, /\/skillswise\/quickfind\/search/, /\/somali\/search/, /\/survey\//, /\/swahili\/search/, /\/syndication\/html\//, /\/tamil\/search/, /\/turkce\/search/, /\/ukchina\/simp\/search/, /\/ukchina\/trad\/search/, /\/ukrainian\/search/, /\/urdu\/search/, /\/uzbek\/search/, /\/vietnamese\/search/, /\/weather\/broadband\//, /\/weather\/search/, /\/worldservice\/images\//, /\/worldservice\/psims\//, /\/worldservice\/ssi\//, /\/worldservice\/survey\//, /\/zhongwen\/simp\/search/, /\/zhongwen\/trad\/search/]
      RubyCrawler::Spider.new.parse_robots_txt

      expect(RubyCrawler.configuration.exclude_patterns).to eq(expected)
    end

  end
end
