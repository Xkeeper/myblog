require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/index.atom.builder" do
  before(:each) do
    view.stub!(:enki_config).and_return(Enki::Config.default)

    mock_tag = mock_model(ActsAsTaggableOn::Tag,
      :name => 'code'
    )

    mock_post = mock_model(Post,
      :title             => "A post",
      :body_html         => "Posts contents!",
      :published_at      => 1.year.ago,
      :edited_at         => 1.year.ago,
      :slug              => 'a-post',
      :tags              => [mock_tag]
    )

    assign :posts, [mock_post, mock_post]
  end

  it "should render list of posts" do
    render :template => "/posts/index.atom.builder"
  end

  it "should render list of posts with a tag" do
    assigns[:tag] = 'code'
    render :template => "/posts/index.atom.builder"
  end
end
