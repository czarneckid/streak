require 'spec_helper'

describe Streak::Collector do
  describe '#aggregate' do
    it 'should collect the right statistics' do
      streak_value_for(Streak.positive_key, 'david').should == 0
      streak_value_for(Streak.positive_streak_key, 'david').should == 0
      streak_value_for(Streak.negative_key, 'david').should == 0
      streak_value_for(Streak.negative_streak_key, 'david').should == 0
      streak_value_for(Streak.total_key, 'david').should == 0
      Streak.aggregate('david', 1)
      streak_value_for(Streak.positive_key, 'david').should == 1
      streak_value_for(Streak.positive_streak_key, 'david').should == 1
      streak_value_for(Streak.negative_key, 'david').should == 0
      streak_value_for(Streak.total_key, 'david').should == 1
      Streak.aggregate('david', 1)
      streak_value_for(Streak.positive_key, 'david').should == 2
      streak_value_for(Streak.positive_streak_key, 'david').should == 2
      streak_value_for(Streak.total_key, 'david').should == 2
      Streak.aggregate('david', -1)
      streak_value_for(Streak.positive_key, 'david').should == 0
      streak_value_for(Streak.positive_streak_key, 'david').should == 2
      streak_value_for(Streak.negative_key, 'david').should == 1
      streak_value_for(Streak.negative_streak_key, 'david').should == 1
      streak_value_for(Streak.total_key, 'david').should == 3
      Streak.aggregate('david', 3)
      streak_value_for(Streak.positive_key, 'david').should == 3
      streak_value_for(Streak.positive_streak_key, 'david').should == 3
      streak_value_for(Streak.negative_key, 'david').should == 0
      streak_value_for(Streak.negative_streak_key, 'david').should == 1
      streak_value_for(Streak.total_key, 'david').should == 6
    end
  end

  describe '#statistics' do
    it 'should return the default list of statistics if no keys list is provided' do
      Streak.aggregate('david', 3)
      Streak.aggregate('david', -2)
      Streak.aggregate('david', 5)
      Streak.aggregate('david', -1)

      Streak.statistics('david').should == {:wins => 0, :wins_total => 8, :wins_streak => 5, :losses => 1, :losses_total => 3, :losses_streak => 2, :total => 11}
    end

    it 'should return the specified list of statistics if a keys list is provided' do
      Streak.aggregate('david', 3)
      Streak.aggregate('david', -2)
      Streak.aggregate('david', 5)
      Streak.aggregate('david', -1)

      Streak.statistics('david', [Streak.positive_streak_key, Streak.negative_streak_key]).should == {:wins_streak => 5, :losses_streak => 2}
    end
  end

  describe '#reset_statistics' do
    it 'should reset all statistics' do
      Streak.aggregate('david', 3)
      Streak.aggregate('david', -2)
      Streak.aggregate('david', 5)
      Streak.aggregate('david', -1)

      Streak.statistics('david').should == {:wins => 0, :wins_total => 8, :wins_streak => 5, :losses => 1, :losses_total => 3, :losses_streak => 2, :total => 11}

      Streak.reset_statistics('david')

      Streak.statistics('david').should == {:wins => 0, :wins_total => 0, :wins_streak => 0, :losses => 0, :losses_total => 0, :losses_streak => 0, :total => 0}

      Streak.aggregate('david', 3)
      Streak.aggregate('david', -2)
      Streak.aggregate('david', 5)
      Streak.aggregate('david', -1)

      Streak.statistics('david').should == {:wins => 0, :wins_total => 8, :wins_streak => 5, :losses => 1, :losses_total => 3, :losses_streak => 2, :total => 11}

      Streak.reset_statistics('david', [Streak.positive_key, Streak.positive_total_key, Streak.positive_streak_key, Streak.negative_key, Streak.negative_total_key, Streak.negative_streak_key, Streak.total_key])

      Streak.statistics('david').should == {:wins => 0, :wins_total => 0, :wins_streak => 0, :losses => 0, :losses_total => 0, :losses_streak => 0, :total => 0}
    end
  end

  describe 'custom keys in #aggregate, #statistics and #reset_statistics' do
    it 'should allow you to use custom keys different from the configured keys' do
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

      Streak.statistics('david').should == {:wins => 0, :wins_total => 8, :wins_streak => 5, :losses => 1, :losses_total => 3, :losses_streak => 2, :total => 11}
      Streak.statistics('david', custom_keys.values).should == {:kills => 0, :kills_total => 7, :kills_streak => 6, :deaths => 3, :deaths_total => 10, :deaths_streak => 7, :kills_deaths_total => 17}

      Streak.reset_statistics('david')
      Streak.statistics('david').should == {:wins => 0, :wins_total => 0, :wins_streak => 0, :losses => 0, :losses_total => 0, :losses_streak => 0, :total => 0}
      Streak.statistics('david', custom_keys.values).should == {:kills => 0, :kills_total => 7, :kills_streak => 6, :deaths => 3, :deaths_total => 10, :deaths_streak => 7, :kills_deaths_total => 17}
      Streak.reset_statistics('david', custom_keys.values)
      Streak.statistics('david', custom_keys.values).should == {:kills => 0, :kills_total => 0, :kills_streak => 0, :deaths => 0, :deaths_total => 0, :deaths_streak => 0, :kills_deaths_total => 0}
    end
  end

  describe '#remove_statistics' do
    it 'should remove all the statistics for a given ID' do
      Streak.aggregate('david', 3)
      Streak.aggregate('david', -2)
      Streak.aggregate('david', 5)
      Streak.aggregate('david', -1)

      Streak.statistics('david').should == {:wins => 0, :wins_total => 8, :wins_streak => 5, :losses => 1, :losses_total => 3, :losses_streak => 2, :total => 11}

      Streak.remove_statistics('david')
      Streak.statistics('david').should == {:wins => 0, :wins_total => 0, :wins_streak => 0, :losses => 0, :losses_total => 0, :losses_streak => 0, :total => 0}

      Streak.redis.exists("#{Streak.namespace}:david").should be_false
    end
  end
end