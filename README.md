# Streak

Streak is a gem for calculating win/loss streaks. It uses Redis as its backend for collecting the data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'streak'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install streak
```

## Usage

```ruby
# Configuration

Streak.configure do |configuration|
  configuration.redis = Redis.new
  configuration.namespace = 'streak'
  configuration.positive_key = 'wins'
  configuration.positive_total_key = 'wins_total'
  configuration.positive_streak_key = 'wins_streak'
  configuration.negative_key = 'losses'
  configuration.negative_total_key = 'losses_total'
  configuration.negative_streak_key = 'losses_streak'
  configuration.total_key = 'total'
end

Streak.aggregate('david', 3) # 3 wins
Streak.aggregate('david', -2) # 2 losses
Streak.aggregate('david', 5) # 5 wins
Streak.aggregate('david', -1) # 1 loss

Streak.statistics('david')
 => {:wins=>0, :wins_total => 8, :wins_streak=>5, :losses=>1, :losses_total => 3, :losses_streak=>2, :total=>11} 

Streak.statistics('david', [Streak.positive_streak_key, Streak.negative_streak_key])
 => {:wins_streak=>5, :losses_streak=>2} 
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 David Czarnecki. See LICENSE for further details.
