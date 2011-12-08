require 'test_helper'

class ZonasControllerTest < ActionController::TestCase
  setup do
    @zona = zonas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:zonas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create zona" do
    assert_difference('Zona.count') do
      post :create, :zona => @zona.attributes
    end

    assert_redirected_to zona_path(assigns(:zona))
  end

  test "should show zona" do
    get :show, :id => @zona.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @zona.to_param
    assert_response :success
  end

  test "should update zona" do
    put :update, :id => @zona.to_param, :zona => @zona.attributes
    assert_redirected_to zona_path(assigns(:zona))
  end

  test "should destroy zona" do
    assert_difference('Zona.count', -1) do
      delete :destroy, :id => @zona.to_param
    end

    assert_redirected_to zonas_path
  end
end
