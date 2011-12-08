require 'test_helper'

class InteresesControllerTest < ActionController::TestCase
  setup do
    @interes = intereses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:intereses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interes" do
    assert_difference('Interes.count') do
      post :create, :interes => @interes.attributes
    end

    assert_redirected_to interes_path(assigns(:interes))
  end

  test "should show interes" do
    get :show, :id => @interes.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @interes.to_param
    assert_response :success
  end

  test "should update interes" do
    put :update, :id => @interes.to_param, :interes => @interes.attributes
    assert_redirected_to interes_path(assigns(:interes))
  end

  test "should destroy interes" do
    assert_difference('Interes.count', -1) do
      delete :destroy, :id => @interes.to_param
    end

    assert_redirected_to intereses_path
  end
end
