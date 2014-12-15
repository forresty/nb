# nb

[![Code Climate](https://codeclimate.com/github/forresty/nb/badges/gpa.svg)](https://codeclimate.com/github/forresty/nb)
[![Build Status](https://travis-ci.org/forresty/nb.svg?branch=master)](https://travis-ci.org/forresty/nb)
[![Gem Version](https://badge.fury.io/rb/nb.svg)](http://badge.fury.io/rb/nb)

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
classifier = NaiveBayes::Classifier.new :love, :hate

classifier.train :love, 'I', 'love', 'you'
classifier.train :hate, 'I', 'hate', 'you'

classifier.classifications(*%w{ I love you }).should == [[:love, 0.5], [:hate, 0.25]]
classifier.classify(*%w{ I love you }).should == [:love, 0.5]
classifier.classify(*%w{ love }).should == [:love, 0.5]
```

### ability to view top tokens

`classifier.top_tokens_of_category(:spam)`

```
+------------+------+--------------------+
| 学生       | 1966 | 0.9995149465854383 |
| 多劳多得   | 1953 | 0.999511719439795  |
| 党         | 1517 | 0.9993714712416684 |
| 结         | 1327 | 0.9992815430836995 |
| 工资       | 1213 | 0.9992140742313297 |
| 不等       | 1135 | 0.999160108836817  |
| 诚聘       | 1107 | 0.9991388832706672 |
| 咨询       | 1095 | 0.9991294545902496 |
| 加入       | 1071 | 0.9991099639327047 |
| 限制       | 1046 | 0.9990887109454397 |
| 50         | 1041 | 0.9990843379645474 |
| 上网       | 1020 | 0.9990655037161098 |
| 流动资金   | 952  | 0.9989988208099915 |
| 曰         | 902  | 0.9989433817121107 |
| 办公室     | 861  | 0.9988931222482719 |
| 职员       | 827  | 0.9988476682254364 |
| 绝对       | 823  | 0.9988420740701035 |
+------------+------+--------------------+
```

### support default category

in case the probability of each category is too low:

```ruby
@classifier = NaiveBayes::Classifer.new :spam, :ham
@classifier.default_category = :ham
```

```
bayes filter mark as spam: false
bayes classifications: [[:ham, 5.044818725004143e-80], [:spam, 1.938475275819746e-119]]

bayes filter mark as spam: false
bayes classifications: [[:spam, 0.0], [:ham, 0.0]]
```

## Credits

- [classifier gem](https://github.com/cardmagic/classifier)
- [naive_bayes gem](https://github.com/reddavis/Naive-Bayes)
- [nbayes gem](https://github.com/oasic/nbayes)

## Contributing

1. Fork it ( https://github.com/forresty/nb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
