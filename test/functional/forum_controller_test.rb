require File.dirname(__FILE__) + '/../test_helper'
require 'forum_controller'

# Re-raise errors caught by the controller.
class ForumController; def rescue_action(e) raise e end; end

class ForumControllerTest < Test::Unit::TestCase
  def setup
    @controller = ForumController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
