require 'test_helper'

class StaticPagesControllerTest < BaseControllerTest

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", @baseUrl
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | #{@baseUrl}"
  end
  
  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | #{@baseUrl}"
  end
  
  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | #{@baseUrl}"
  end

end
