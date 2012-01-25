class IntencionesController < ApplicationController
  # GET /intenciones
  # GET /intenciones.xml
  def index
    @intenciones = Intencion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @intenciones }
    end
  end

  # GET /intenciones/1
  # GET /intenciones/1.xml
  def show
    @intencion = Intencion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @intencion }
    end
  end

  # GET /intenciones/new
  # GET /intenciones/new.xml
  def new
    @intencion = Intencion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @intencion }
    end
  end

  # GET /intenciones/1/edit
  def edit
    @intencion = Intencion.find(params[:id])
  end

  # POST /intenciones
  # POST /intenciones.xml
  def create
    @intencion = Intencion.new(params[:intencion])

    respond_to do |format|
      if @intencion.save
        format.html { redirect_to(@intencion, :notice => 'Intencion was successfully created.') }
        format.xml  { render :xml => @intencion, :status => :created, :location => @intencion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @intencion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /intenciones/1
  # PUT /intenciones/1.xml
  def update
    @intencion = Intencion.find(params[:id])

    respond_to do |format|
      if @intencion.update_attributes(params[:intencion])
        format.html { redirect_to(@intencion, :notice => 'Intencion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @intencion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /intenciones/1
  # DELETE /intenciones/1.xml
  def destroy
    @intencion = Intencion.find(params[:id])
    @intencion.destroy

    respond_to do |format|
      format.html { redirect_to(intenciones_url) }
      format.xml  { head :ok }
    end
  end
end
