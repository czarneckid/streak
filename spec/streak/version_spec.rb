require 'spec_helper'

describe 'Streak::VERSION' do
  it 'should be the correct version' do
    Streak::VERSION.should == '0.3.0'
  end
end