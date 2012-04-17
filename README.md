# Streak

Streak is a gem for calculating win/loss streaks

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
Streak.aggregate('david', 3) # 3 wins
Streak.aggregate('david', -2) # 2 losses
Streak.aggregate('david', 5) # 5 wins
Streak.aggregate('david', -1) # 1 loss

Streak.statistics('david').should == [0, 5, 1, 2, 11] # 0 current wins, 5 win streak, 1 current loss, 2 loss streak, 11 total "plays"
Streak.statistics('david', [Streak.wins_streak_key, Streak.losses_streak_key]).should == [5, 2] # 5 win streak, 2 loss streak
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 David Czarnecki. See LICENSE for further details.
