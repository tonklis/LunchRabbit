class InteresesController < ApplicationController
  # GET /intereses
  # GET /intereses.xml
  def index
    @intereses = Interes.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @intereses }
    end
  end

  # GET /intereses/1
  # GET /intereses/1.xml
  def show
    @interes = Interes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interes }
      format.json { render :json => @interes }
    end
  end

  # GET /intereses/new
  # GET /intereses/new.xml
  def new
    @interes = Interes.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interes }
    end
  end

  # GET /intereses/1/edit
  def edit
    @interes = Interes.find(params[:id])
  end

  # POST /intereses
  # POST /intereses.xml
  def create
    @interes = Interes.new(params[:interes])

    respond_to do |format|
      if @interes.save
        format.html { redirect_to(@interes, :notice => 'Interes was successfully created.') }
        format.xml  { render :xml => @interes, :status => :created, :location => @interes }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @interes.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /intereses/1
  # PUT /intereses/1.xml
  def update
    @interes = Interes.find(params[:id])

    respond_to do |format|
      if @interes.update_attributes(params[:interes])
        format.html { redirect_to(@interes, :notice => 'Interes was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interes.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /intereses/1
  # DELETE /intereses/1.xml
  def destroy
    @interes = Interes.find(params[:id])
    @interes.destroy

    respond_to do |format|
      format.html { redirect_to(intereses_url) }
      format.xml  { head :ok }
    end
  end

  def busqueda
    if params[:term].nil? or params[:term] == ""
      @intereses = []
    else
      @intereses = Interes.search(params[:term])
    end
    ActiveRecord::Base.include_root_in_json = false
    render :json => @intereses

  end
end
