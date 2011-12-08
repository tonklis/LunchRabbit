require 'test_helper'

class InvitacionesControllerTest < ActionController::TestCase
  setup do
    @invitacion = invitaciones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invitaciones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invitacion" do
    assert_difference('Invitacion.count') do
      post :create, :invitacion => @invitacion.attributes
    end

    assert_redirected_to invitacion_path(assigns(:invitacion))
  end

  test "should show invitacion" do
    get :show, :id => @invitacion.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @invitacion.to_param
    assert_response :success
  end

  test "should update invitacion" do
    put :update, :id => @invitacion.to_param, :invitacion => @invitacion.attributes
    assert_redirected_to invitacion_path(assigns(:invitacion))
  end

  test "should destroy invitacion" do
    assert_difference('Invitacion.count', -1) do
      delete :destroy, :id => @invitacion.to_param
    end

    assert_redirected_to invitaciones_path
  end
end
