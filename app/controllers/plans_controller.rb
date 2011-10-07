class PlansController < ApplicationController
  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.find(:all, :conditions => "status <> 'Upcoming'", :order => :when_loaded)
    @plans_upcoming = Plan.find(:all, :conditions => {:status => "Upcoming"})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plans }
    end
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plan }
    end
  end

  # GET /plans/new
  # GET /plans/new.json
  def new
    @plan = Plan.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plan }
    end
  end

  # GET /plans/1/edit
  def edit
    @plan = Plan.find(params[:id])
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(params[:plan])
    @plan.when_upcoming = Time.now

    respond_to do |format|
      if @plan.save
        format.html { redirect_to plans_url, notice: 'Plan was successfully created.' }
        format.json { render json: @plan, status: :created, location: @plan }
      else
        format.html { render action: "new" }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plans/1
  # PUT /plans/1.json
  def update
    @plan = Plan.find(params[:id])
    case params[:status]
    when 'Loaded'
      @plan.status = 'Loaded'
      @plan.when_loaded = Time.now
    when 'Needs Contours'
      @plan.status = 'Needs Contours'
      @plan.when_needs_contours = Time.now
    when 'Needs Plan'
      @plan.status = 'Needs Plan'
      @plan.when_needs_plan = Time.now
    when 'Needs Approval'
      @plan.status = 'Needs Approval'
      @plan.when_needs_approval = Time.now
    when 'Needs Finalizing'
      @plan.status = 'Needs Finalizing'
      @plan.when_needs_finalizing = Time.now
    when 'Finalized'
      @plan.status = 'Finalized'
      @plan.when_finalized = Time.now
    end
    @plan.save

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        format.html { redirect_to plans_url, notice: 'Plan was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "show" }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to plans_url }
      format.json { head :ok }
    end
  end
end
