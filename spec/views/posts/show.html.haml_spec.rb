require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/show.html.haml" do
  include UrlHelper

  before(:each) do
    view.stub!(:enki_config).and_return(Enki::Config.default)

    mock_tag = mock_model(ActsAsTaggableOn::Tag,
      :name => 'code'
    )

    @post = mock_model(Post,
      :title             => "A post",
      :body_html         => "Posts contents!",
      :published_at      => 1.year.ago,
      :slug              => 'a-post',
      :tags              => [mock_tag]
    )
    assign :post, @post
  end

  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it "should render a post" do
    render :template => "/posts/show.html.haml"
  end
end

