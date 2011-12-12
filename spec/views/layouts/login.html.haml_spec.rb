require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/login.html.haml" do
  it 'renders' do
    view.stub!(:enki_config).and_return(Enki::Config.default)
    render :template => '/layouts/login.html.haml'
  end
end
