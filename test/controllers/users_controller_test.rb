require 'test_helper'

class UsersControllerTest < BaseControllerTest
  test "should get new" do
    get :new
    assert_response :success
    assert_select 'title', "Sign up | #{@baseUrl}"
  end

end
