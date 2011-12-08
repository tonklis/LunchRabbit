require 'test_helper'

class GruposControllerTest < ActionController::TestCase
  setup do
    @grupo = grupos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grupos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grupo" do
    assert_difference('Grupo.count') do
      post :create, :grupo => @grupo.attributes
    end

    assert_redirected_to grupo_path(assigns(:grupo))
  end

  test "should show grupo" do
    get :show, :id => @grupo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @grupo.to_param
    assert_response :success
  end

  test "should update grupo" do
    put :update, :id => @grupo.to_param, :grupo => @grupo.attributes
    assert_redirected_to grupo_path(assigns(:grupo))
  end

  test "should destroy grupo" do
    assert_difference('Grupo.count', -1) do
      delete :destroy, :id => @grupo.to_param
    end

    assert_redirected_to grupos_path
  end
end
