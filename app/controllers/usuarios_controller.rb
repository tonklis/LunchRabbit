class UsuariosController < ApplicationController
  # GET /usuarios
  # GET /usuarios.xml
  def index
    @usuarios = Usuario.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @usuarios }
    end
  end

  # GET /usuarios/1
  # GET /usuarios/1.xml
  def show
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @usuario }
      format.json { render :json => @usuario, :include => [ :intereses, :invitaciones_enviadas, :invitaciones_recibidas] }
    end
  end

  # GET /usuarios/new
  # GET /usuarios/new.xml
  def new
    @usuario = Usuario.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @usuario }
    end
  end

  # GET /usuarios/1/edit
  def edit
    @usuario = Usuario.find(params[:id])
  end

  # POST /usuarios
  # POST /usuarios.xml
  def create
    @usuario = Usuario.new(params[:usuario])

    respond_to do |format|
      if @usuario.save
        format.html { redirect_to(@usuario, :notice => 'Usuario was successfully created.') }
        format.xml  { render :xml => @usuario, :status => :created, :location => @usuario }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /usuarios/1
  # PUT /usuarios/1.xml
  def update
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      if @usuario.update_attributes(params[:usuario])
        format.html { redirect_to(@usuario, :notice => 'Usuario was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.xml
  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy

    respond_to do |format|
      format.html { redirect_to(usuarios_url) }
      format.xml  { head :ok }
    end
  end

  # GET /usuarios/encuentra_o_crea/[facebook_id]
  def encuentra_o_crea
    facebook_id = params[:id]
    @usuario = Usuario.encuentra_o_crea(facebook_id)
    respond_to do |format|
      format.xml  { render :xml => @usuario }
      format.json {render :json => @usuario,  :include => [ :intereses, :invitaciones_enviadas, :invitaciones_recibidas] }
    end
  end

  # GET /usuarios/actualiza/[facebook_id]
  def actualiza
    @usuario = Usuario.actualiza params
    respond_to do |format|
      format.xml {render :xml => @usuario}
      format.json {render :json => @usuario}
    end
  end

  # GET /usuarios/busqueda/[facebook_id]&limit=[limit]
  def busqueda
    @usuarios = Usuario.busqueda(params[:id], params[:limit])
    respond_to do |format|
      format.xml {render :xml => @usuarios}
      format.json {render :json => @usuarios}
    end
  end

end
