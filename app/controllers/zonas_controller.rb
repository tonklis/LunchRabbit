class ZonasController < ApplicationController
  # GET /zonas
  # GET /zonas.xml
  def index
    @zonas = Zona.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @zonas }
    end
  end

  # GET /zonas/1
  # GET /zonas/1.xml
  def show
    @zona = Zona.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @zona }
      format.json { render :json => @zona }
    end
  end

  # GET /zonas/new
  # GET /zonas/new.xml
  def new
    @zona = Zona.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @zona }
    end
  end

  # GET /zonas/1/edit
  def edit
    @zona = Zona.find(params[:id])
  end

  # POST /zonas
  # POST /zonas.xml
  def create
    @zona = Zona.new(params[:zona])

    respond_to do |format|
      if @zona.save
        format.html { redirect_to(@zona, :notice => 'Zona was successfully created.') }
        format.xml  { render :xml => @zona, :status => :created, :location => @zona }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @zona.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /zonas/1
  # PUT /zonas/1.xml
  def update
    @zona = Zona.find(params[:id])

    respond_to do |format|
      if @zona.update_attributes(params[:zona])
        format.html { redirect_to(@zona, :notice => 'Zona was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @zona.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /zonas/1
  # DELETE /zonas/1.xml
  def destroy
    @zona = Zona.find(params[:id])
    @zona.destroy

    respond_to do |format|
      format.html { redirect_to(zonas_url) }
      format.xml  { head :ok }
    end
  end
end
