require File.dirname(__FILE__) + '/../spec_helper'


describe Post, "integration" do
  describe 'setting tag_list' do
    it 'increments tag counter cache' do
      post1 = Post.create!(:title => 'My Post', :body => "body", :tag_list => "ruby")
      post2 = Post.create!(:title => 'My Post', :body => "body", :tag_list => "ruby")
      Post.tag_counts.find_by_name('ruby').count.should == 2
      Post.last.destroy
      Post.tag_counts.find_by_name('ruby').count.should == 1
    end
  end
end

describe Post, ".find_recent" do
  it 'finds the most recent posts that were published before now' do
    30.times{|i| Factory.create(:post, :published_at => i.days.ago)}
    @posts = Post.find_recent
    @posts.size.should eq Post::DEFAULT_LIMIT
    @posts[0...-1].each_index do |i|
      @posts[i].published_at.should >= @posts[i+1].published_at
    end
  end

  it 'finds the most recent posts that were published before now with a tag' do
    test_tag = %w(rails_tag)
    30.times{|i| Factory.create(:post, :published_at => i.days.ago)}
    30.times{|i| Factory.create(:post, :published_at => i.days.ago, :tag_list => test_tag)}
    @posts = Post.find_recent(:tag => test_tag)
    @posts.size.should eq Post::DEFAULT_LIMIT
    @posts[0...-1].each_index do |i|
      @posts[i].published_at.should >= @posts[i+1].published_at
      @posts[i].tag_list.should eq test_tag
    end
  end

  it 'finds all posts grouped by month' do
    now = Time.now
    Time.stub!(:now).and_return(now)
    posts = [1, 1, 2].collect {|month| mock_model(Post, :month => month) }
    Post.should_receive(:find).with(:all, {
      :order      => 'posts.published_at DESC',
      :conditions => ['published_at < ?', now]
    }).and_return(posts)
    months = Post.find_all_grouped_by_month.collect {|month| [month.date, month.posts]}
    months.should == [[1, [posts[0], posts[1]]], [2, [posts[2]]]]
  end
end

describe Post, '#generate_slug' do
  it 'makes a slug from the title if slug if blank' do
    post = Post.new(:slug => '', :title => 'my title')
    post.generate_slug
    post.slug.should == 'my-title'
  end

  it 'replaces & with and' do
    post = Post.new(:slug => 'a & b & c')
    post.generate_slug
    post.slug.should == 'a-and-b-and-c'
  end

  it 'replaces non alphanumeric characters with -' do
    post = Post.new(:slug => 'a@#^*(){}b')
    post.generate_slug
    post.slug.should == 'a-b'
  end

  it 'does not modify title' do
    post = Post.new(:title => 'My Post')
    post.generate_slug
    post.title.should == 'My Post'
  end
end

describe Post, '#tag_list=' do
  it 'accept an array argument so it is symmetrical with the reader' do
    p = Post.new
    p.tag_list = ["a", "b"]
    p.tag_list.should == ["a", "b"]
  end
end

describe Post, "#set_dates" do
  describe 'when minor_edit is false' do
    it 'sets edited_at to current time' do
      now = Time.now
      Time.stub!(:now).and_return(now)

      post = Post.new(:edited_at => 1.day.ago)
      post.stub!(:minor_edit?).and_return(false)
      post.set_dates
      post.edited_at.should == now
    end
  end

  describe 'when edited_at is nil' do
    it 'sets edited_at to current time' do
      now = Time.now
      Time.stub!(:now).and_return(now)

      post = Post.new
      post.stub!(:minor_edit?).and_return(true)
      post.set_dates
      post.edited_at.should == now
    end
  end

  describe 'when minor_edit is true' do
    it 'does not changed edited_at' do
      post = Post.new(:edited_at => now = 1.day.ago)
      post.stub!(:minor_edit?).and_return(true)
      post.set_dates
      post.edited_at.should == now
    end
  end

  it 'sets published_at by parsing published_at_natural with chronic' do
    now = Time.now
    post = Post.new(:published_at_natural => 'now')
    Chronic.should_receive(:parse).with('now').and_return(now)
    post.set_dates
    post.published_at.should == now
  end
end

describe Post, "#minor_edit" do
  it('returns "1" by default') { Post.new.minor_edit.should == "1" }
end

describe Post, '#published?' do
  before(:each) do
    @post = Post.new
  end

  it "should return false if published_at is not filled" do
    @post.should_not be_published
  end

  it "should return true if published_at is filled" do
    @post.published_at = Time.now
    @post.should be_published
  end
end

describe Post, "#minor_edit?" do
  it('returns true when minor_edit is 1')  { Post.new(:minor_edit => "1").minor_edit?.should == true }
  it('returns false when minor_edit is 0') { Post.new(:minor_edit => "0").minor_edit?.should == false }
  it('returns true by default')            { Post.new.minor_edit?.should == true }
end

describe Post, 'before validation' do
  it 'calls #generate_slug' do
    post = Post.new(:title => "My Post", :body => "body")
    post.valid?
    post.slug.should_not be_blank
  end

  it 'calls #set_dates' do
    post = Post.new(:title => "My Post", :body => "body")
    post.valid?
    post.edited_at.should_not be_blank
    post.published_at.should_not be_blank
  end
end

=begin
describe Post, '#denormalize_comments_count!' do
  it 'updates approved_comments_count without triggering AR callbacks' do
    p = Post.new
    p.id = 999
    p.stub!(:approved_comments).and_return(stub("approved_comments association", :count => 9))
    Post.should_receive(:update_all).with(["approved_comments_count = ?", 9], ["id = ?", 999])
    p.denormalize_comments_count!
  end
end
=end

describe Post, 'validations' do
  def valid_post_attributes
    {
      :title                => "My Post",
      :slug                 => "my-post",
      :body                 => "hello this is my post",
      :published_at_natural => 'now'
    }
  end

  it 'is valid with valid_post_attributes' do
    Post.new(valid_post_attributes).should be_valid
  end

  it 'is invalid with no title' do
    Post.new(valid_post_attributes.merge(:title => '')).should_not be_valid
  end

  it 'is invalid with no body' do
    Post.new(valid_post_attributes.merge(:body => '')).should_not be_valid
  end

  it 'is invalid with bogus published_at_natural' do
    Post.new(valid_post_attributes.merge(:published_at_natural => 'bogus')).should_not be_valid
  end
end

=begin
describe Post, 'being destroyed' do
  it 'destroys all comments' do
    Post.reflect_on_association(:comments).options[:dependent].should == :destroy
  end
end
=end

describe Post, '.build_for_preview' do
  before(:each) do
    @post = Post.build_for_preview(:title => 'My Post', :body => "body", :tag_list => "ruby")
  end

  it 'returns a new post' do
    @post.should be_new_record
  end

  it 'generates slug' do
    @post.slug.should_not be_nil
  end

  it 'sets date' do
    @post.edited_at.should_not be_nil
    @post.published_at.should_not be_nil
  end

  it 'applies filter to body' do
    @post.body_html.should == '<p>body</p>'
  end

  it 'generates tags from tag_list' do
    @post.tags.collect {|tag| tag.name}.should == ['ruby']
  end
end