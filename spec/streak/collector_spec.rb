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
      Streak.aggregate('david', 1)
      Streak.aggregate('david', 1)
      Streak.aggregate('david', 1)
      streak_value_for(Streak.wins_key, 'david').should == 3
      streak_value_for(Streak.wins_streak_key, 'david').should == 3
      streak_value_for(Streak.losses_key, 'david').should == 0
      streak_value_for(Streak.losses_streak_key, 'david').should == 1
      streak_value_for(Streak.total_key, 'david').should == 6
    end
  end
end