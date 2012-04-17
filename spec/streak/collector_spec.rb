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
end