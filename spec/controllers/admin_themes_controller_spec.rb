require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::ThemesController do
  fixtures :users, :themes, :groups, :group_users, :permissions
  
  before do
    login_as(:administrator)
    @theme = mock_model(Theme)
    @themes = [@theme]
  end

  #Delete this example and add some real ones
  it "should be able show all themes" do
    get 'index'
    response.should render_template("index")
  end

end
