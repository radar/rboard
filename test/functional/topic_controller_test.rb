require File.dirname(__FILE__) + '/../test_helper'
require 'topic_controller'

# Re-raise errors caught by the controller.
class TopicController; def rescue_action(e) raise e end; end

class TopicControllerTest < Test::Unit::TestCase
  def setup
    @controller = TopicController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
