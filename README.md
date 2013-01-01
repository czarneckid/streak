# streak

streak is a gem for calculating win/loss streaks. It uses Redis as its backend for collecting the data.

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

streak is configurable with respect to its keys to allow for tracking other positive/negative things in a game like wins and losses, kills and deaths, etc.

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
 => {:wins=>0, :wins_total=>8, :wins_streak=>5, :losses=>1, :losses_total=>3, :losses_streak=>2, :total=>11}

Streak.statistics('david', [Streak.positive_streak_key, Streak.negative_streak_key])
 => {:wins_streak=>5, :losses_streak=>2}

Streak.reset_statistics('david')
Streak.statistics('david')
 => {:wins=>0, :wins_total=>0, :wins_streak=>0, :losses=>0, :losses_total=>0, :losses_streak=>0, :total=>0}
```

You can also pass a custom set of keys to be used in the `aggregate` call if you want to
use a different set of positive/negative things than what is setup in the configuration.
Below is a complete example:

```ruby
custom_keys = {
  :positive_key => 'kills',
  :positive_total_key => 'kills_total',
  :positive_streak_key => 'kills_streak',
  :negative_key => 'deaths',
  :negative_total_key => 'deaths_total',
  :negative_streak_key => 'deaths_streak',
  :total_key => 'kills_deaths_total'
}

Streak.aggregate('david', 1, custom_keys)
Streak.aggregate('david', -7, custom_keys)
Streak.aggregate('david', 6, custom_keys)
Streak.aggregate('david', -3, custom_keys)

Streak.aggregate('david', 3)
Streak.aggregate('david', -2)
Streak.aggregate('david', 5)
Streak.aggregate('david', -1)

Streak.statistics('david')
 => {:wins=>0, :wins_total=>8, :wins_streak=>5, :losses=>1, :losses_total=>3, :losses_streak=>2, :total=>11}
Streak.statistics('david', custom_keys.values)
 => {:kills=>0, :kills_total=>7, :kills_streak=>6, :deaths=>3, :deaths_total=>10, :deaths_streak=>7, :kills_deaths_total=>17}

Streak.reset_statistics('david')
Streak.reset_statistics('david', custom_keys.values)
```

You can remove all data for a given ID using the `remove_all_statistics(id)` method.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012-2013 David Czarnecki. See LICENSE for further details.
