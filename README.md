# RubyCrawler

Welcome to RubyCrawler, a simple web crawler written in Ruby!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_crawler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_crawler

## Usage

Require the gem:

```ruby
require 'ruby_crawler'
```

Configure the start urls and the include/exclude patterns:

```ruby
RubyCrawler.configure do |conf|
  conf.start_urls = ['https://gocardless.com/']
  conf.include_patterns = [/https:\/\/gocardless\.com/]
  conf.exclude_patterns = []
end
```

Include and exclude patterns must both take arrays of regular expressions.

Then kick off a crawl:

```ruby
RubyCrawler.crawl
```

By default, RubyCrawler is polite (i.e. it respects a website's robots.txt file). However, you can change this by setting:

```ruby
RubyCrawler.configure do |conf|
  conf.polite = false
end
```

When you kick off a new crawl, you will see the include and exclude patterns change accordingly.

## Sitemap & Assets

To see the sitemap (i.e. stored urls), just type:

```ruby
RubyCrawler.stored
#  =>
#  ["https://gocardless.com/",
#   "https://gocardless.com/features/",
#   "https://gocardless.com/pricing/",
#   "https://gocardless.com/accountants/",
#   "https://gocardless.com/charities/",
#   "https://gocardless.com/agencies/",
#   "https://gocardless.com/education/",
#   "https://gocardless.com/finance/",
#   "https://gocardless.com/local-government/",
#   "https://gocardless.com/saas/",
#   "https://gocardless.com/telcos/",
#   "https://gocardless.com/utilities/"]
```

whereas to view the assets (css|img|js) on the crawled pages, you can run:

```ruby
RubyCrawler.assets
```

To reset the RubyCrawler's configuration, simply execute:

```ruby
RubyCrawler.reset
```

## TODO and Issues

* Once a crawl kicks off for a very large website, Ctrl+c does not halt the crawl.
* Currently no flushing of stored urls or assets to a dataabse. Everythign is in in-memory.
* Politeness doesn't take into account meta tags with noindex.
* Canonical links in page source not taken into account.
* Current only a global configuration is supported, although it would be possible to implement on a per-spider basis.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DaniG2k/ruby_crawler.

