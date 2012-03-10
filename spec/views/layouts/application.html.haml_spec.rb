require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/application.html.haml" do
  before(:each) do
    view.stub!(:enki_config).and_return(Enki::Config.default)

    mock_tag = mock_model(ActsAsTaggableOn::Tag,
      :name     => 'code',
      :taggings => [mock_model(ActsAsTaggableOn::Tagging)]
    )
    ActsAsTaggableOn::Tag.stub!(:find).and_return([mock_tag])

    mock_page = mock_model(Page,
      :title     => 'about',
      :slug     => 'about'
    )
    Page.stub!(:find).and_return([mock_page])
  end

  it 'renders' do
    render :template => '/layouts/application.html.haml'
  end
end
