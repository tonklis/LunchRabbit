class InvitacionesController < ApplicationController
  # GET /invitaciones
  # GET /invitaciones.xml
  def index
    @invitaciones = Invitacion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitaciones }
    end
  end

  # GET /invitaciones/1
  # GET /invitaciones/1.xml
  def show
    @invitacion = Invitacion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invitacion }
    end
  end

  # GET /invitaciones/new
  # GET /invitaciones/new.xml
  def new
    @invitacion = Invitacion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitacion }
    end
  end

  # GET /invitaciones/1/edit
  def edit
    @invitacion = Invitacion.find(params[:id])
  end

  # POST /invitaciones
  # POST /invitaciones.xml
  def create
    @invitacion = Invitacion.new(params[:invitacion])

    respond_to do |format|
      if @invitacion.save
        format.html { redirect_to(@invitacion, :notice => 'Invitacion was successfully created.') }
        format.xml  { render :xml => @invitacion, :status => :created, :location => @invitacion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invitacion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invitaciones/1
  # PUT /invitaciones/1.xml
  def update
    @invitacion = Invitacion.find(params[:id])

    respond_to do |format|
      if @invitacion.update_attributes(params[:invitacion])
        format.html { redirect_to(@invitacion, :notice => 'Invitacion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invitacion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invitaciones/1
  # DELETE /invitaciones/1.xml
  def destroy
    @invitacion = Invitacion.find(params[:id])
    @invitacion.destroy

    respond_to do |format|
      format.html { redirect_to(invitaciones_url) }
      format.xml  { head :ok }
    end
  end
end
