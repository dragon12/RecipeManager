require 'test_helper'

class FutureLinksControllerTest < ActionController::TestCase
  setup do
    @future_link = future_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:future_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create future_link" do
    assert_difference('FutureLink.count') do
      post :create, future_link: { description: @future_link.description, link: @future_link.link, name: @future_link.name }
    end

    assert_redirected_to future_link_path(assigns(:future_link))
  end

  test "should show future_link" do
    get :show, id: @future_link
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @future_link
    assert_response :success
  end

  test "should update future_link" do
    patch :update, id: @future_link, future_link: { description: @future_link.description, link: @future_link.link, name: @future_link.name }
    assert_redirected_to future_link_path(assigns(:future_link))
  end

  test "should destroy future_link" do
    assert_difference('FutureLink.count', -1) do
      delete :destroy, id: @future_link
    end

    assert_redirected_to future_links_path
  end
end
