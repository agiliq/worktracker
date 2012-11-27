require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get commits" do
    get :commits
    assert_response :success
  end

end
