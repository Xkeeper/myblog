require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/dashboard/show.html.haml" do
  before(:each) do
    view.stub!(:enki_config).and_return(Enki::Config.default)
  end

  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it 'should render' do
    assign :posts, [mock_model(Post,
      :title             => 'A Post',
      :published_at      => Time.now,
      :slug              => 'a-post',
    )]
    assign :stats, Struct.new(:post_count, :tag_count).new(2,1)
    render :template => '/admin/dashboard/show.html.haml'
  end
end
