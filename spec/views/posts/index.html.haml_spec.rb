require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/index.html.haml" do
  before(:each) do
    view.stub!(:enki_config).and_return(Enki::Config.default)

    mock_tag = mock_model(ActsAsTaggableOn::Tag,
      :name => 'code'
    )

    mock_post = mock_model(Post,
      :title             => "A post",
      :body_html         => "Posts contents!",
      :published_at      => 1.year.ago,
      :slug              => 'a-post',
      :tags              => [mock_tag]
    )
    post_array = [mock_post, mock_post]
    post_array.stub!(:total_pages).and_return(0)

    assign :posts, post_array
  end

  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it "should render list of posts" do
    render :template => "/posts/index.html.haml"
  end

  it "should render list of posts with a tag" do
    assigns[:tag] = 'code'
    render :template => "/posts/index.html.haml"
  end
end
