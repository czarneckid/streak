require 'spec_helper'

describe Streak::Configuration do
  describe '#configure' do
    it 'should have default attributes' do
      Streak.configure do |configuration|
        configuration.redis.should_not be_nil
        configuration.namespace.should eql('streak')
        configuration.wins_key.should eql('wins')
        configuration.wins_streak_key.should eql('wins_streak')
        configuration.losses_key.should eql('losses')
        configuration.losses_streak_key.should eql('losses_streak')
        configuration.total_key.should eql('total')
      end
    end
  end
end