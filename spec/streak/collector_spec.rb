require 'spec_helper'

describe Streak::Collector do
  describe '#aggregate' do
    it 'should collect the right statistics' do
      streak_value_for(Streak.wins_key, 'david').should == 0
      streak_value_for(Streak.wins_streak_key, 'david').should == 0
      streak_value_for(Streak.losses_key, 'david').should == 0
      streak_value_for(Streak.losses_streak_key, 'david').should == 0
      streak_value_for(Streak.total_key, 'david').should == 0
      Streak.aggregate('david', 1)
      streak_value_for(Streak.wins_key, 'david').should == 1
      streak_value_for(Streak.wins_streak_key, 'david').should == 1
      streak_value_for(Streak.losses_key, 'david').should == 0
      streak_value_for(Streak.total_key, 'david').should == 1
      Streak.aggregate('david', 1)
      streak_value_for(Streak.wins_key, 'david').should == 2
      streak_value_for(Streak.wins_streak_key, 'david').should == 2
      streak_value_for(Streak.total_key, 'david').should == 2
      Streak.aggregate('david', -1)
      streak_value_for(Streak.wins_key, 'david').should == 0
      streak_value_for(Streak.wins_streak_key, 'david').should == 2
      streak_value_for(Streak.losses_key, 'david').should == 1
      streak_value_for(Streak.losses_streak_key, 'david').should == 1
      streak_value_for(Streak.total_key, 'david').should == 3
      Streak.aggregate('david', 3)
      streak_value_for(Streak.wins_key, 'david').should == 3
      streak_value_for(Streak.wins_streak_key, 'david').should == 3
      streak_value_for(Streak.losses_key, 'david').should == 0
      streak_value_for(Streak.losses_streak_key, 'david').should == 1
      streak_value_for(Streak.total_key, 'david').should == 6
    end    
  end

  describe '#statistics' do
    it 'should return the default list of statistics if no keys list is provided' do
      Streak.aggregate('david', 3)
      Streak.aggregate('david', -2)
      Streak.aggregate('david', 5)
      Streak.aggregate('david', -1)

      Streak.statistics('david').should == [0, 5, 1, 2, 11]
    end

    it 'should return the specified list of statistics if a keys list is provided' do
      Streak.aggregate('david', 3)
      Streak.aggregate('david', -2)
      Streak.aggregate('david', 5)
      Streak.aggregate('david', -1)

      Streak.statistics('david', [Streak.wins_streak_key, Streak.losses_streak_key]).should == [5, 2]
    end
  end
end