require File.dirname(__FILE__) + '/../test_helper'
require 'post_controller'

# Re-raise errors caught by the controller.
class PostController; def rescue_action(e) raise e end; end

class PostControllerTest < Test::Unit::TestCase
  def setup
    @controller = PostController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
