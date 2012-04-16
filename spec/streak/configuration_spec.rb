require 'spec_helper'

describe Streak::Configuration do
  describe '#configure' do
    it 'should have default attributes' do
      Streak.configure do |configuration|
        configuration.redis.should_not be_nil
        configuration.namespace.should eql('streak')        
      end
    end
  end
end