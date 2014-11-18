# nb

[![Code Climate](https://codeclimate.com/github/forresty/nb/badges/gpa.svg)](https://codeclimate.com/github/forresty/nb)
[![Build Status](https://travis-ci.org/forresty/nb.svg?branch=master)](https://travis-ci.org/forresty/nb)

yet another Naive Bayes library

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nb

## Usage

```ruby
bayes = NaiveBayes.new :love, :hate

bayes.train :love, 'I', 'love', 'you'
bayes.train :hate, 'I', 'hate', 'you'

bayes.classifications(*%w{ I love you }).should == [[:love, 0.5], [:hate, 0.25]]
bayes.classify(*%w{ I love you }).should == [:love, 0.5]
bayes.classify(*%w{ love }).should == [:love, 0.5]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/nb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
