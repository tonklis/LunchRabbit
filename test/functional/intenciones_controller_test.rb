require 'test_helper'

class IntencionesControllerTest < ActionController::TestCase
  setup do
    @intencion = intenciones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:intenciones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create intencion" do
    assert_difference('Intencion.count') do
      post :create, :intencion => @intencion.attributes
    end

    assert_redirected_to intencion_path(assigns(:intencion))
  end

  test "should show intencion" do
    get :show, :id => @intencion.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @intencion.to_param
    assert_response :success
  end

  test "should update intencion" do
    put :update, :id => @intencion.to_param, :intencion => @intencion.attributes
    assert_redirected_to intencion_path(assigns(:intencion))
  end

  test "should destroy intencion" do
    assert_difference('Intencion.count', -1) do
      delete :destroy, :id => @intencion.to_param
    end

    assert_redirected_to intenciones_path
  end
end
