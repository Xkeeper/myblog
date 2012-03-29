require File.dirname(__FILE__) + '/../spec_helper'

describe Stats do
  describe '#post_count' do
    it 'returns the total number of posts, published or not' do
      Post.should_receive(:count).and_return(2)
      Stats.new.post_count.should == 2
    end
  end
end
