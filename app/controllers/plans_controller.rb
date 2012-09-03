class PlansController < ApplicationController
  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.find(:all, :conditions => ['status <> ? AND is_active == ?', 'Upcoming', true], :order => :when_needs_image_review)
    @plans_upcoming = Plan.find(:all, :conditions => {:status => "Upcoming", :is_active => true})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plans }
    end
  end

  def indexlist
     @plans = Plan.find(:all, :conditions => ['status <> ? AND is_active == ?', 'Upcoming', true], :order => :when_needs_image_review)
     @plans_upcoming = Plan.find(:all, :conditions => {:status => "Upcoming", :is_active => true})

     respond_to do |format|
       format.html # indexlist.html.erb
       format.json { render json: @plans }
     end
   end  
   
   def needsMDContours
      @plans = Plan.find(:all, :conditions => ['status == ? AND is_active == ?', 'Needs MD Contours', true],
       :order => :when_needs_md_contours)

      respond_to do |format|
        format.html # indexlist.html.erb
        format.json { render json: @plans }
      end
    end
  

  # GET /plans/1
  # GET /plans/1.json
  def show
    @plan = Plan.find(params[:id])
    @comments = Comment.find(:all, :conditions => {:plan_id => @plan.id}, :order => "created_at DESC")

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

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(params[:plan])
    @plan.when_upcoming = Time.now
    
    respond_to do |format|
      if @plan.save
        
        if params[:comment] != ""
          @comment = Comment.create(:content => params[:comment], :plan_id => @plan.id)
        end
        
        format.html { redirect_to indexlist_url, notice: 'Plan was successfully created.' }
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
    if params[:status] != 'no change'
      @plan.status = params[:status]
      case @plan.status
      when 'Needs Records Review'
        @plan.when_needs_image_review = Time.now
      when 'Waiting for Consult'
        @plan.when_waiting_for_consult = Time.now
      when 'Waiting for Setup'
        @plan.when_needs_setup = Time.now
      when 'Needs Dosimetry Prep'
        @plan.when_needs_preparation = Time.now      
      when 'Needs MD Contours'
        @plan.when_needs_md_contours = Time.now
      when 'Needs Plan'
        @plan.when_needs_plan = Time.now
      when 'Needs Approval'
        @plan.when_needs_approval = Time.now      
      when 'Needs Finalizing'
        @plan.when_needs_finalizing = Time.now
      when 'Ready for Treatment'
        @plan.when_ready_for_treatment = Time.now
      when 'In Treatment'
        @plan.when_in_treatment = Time.now
      when 'Finished Treatment'
        @plan.when_finished_treatment = Time.now            
      end
    end
    @plan.save
    
    if params[:comment] != ""
      @comment = Comment.create(:content => params[:comment], :plan_id => @plan.id)
    end
      
    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        format.html { redirect_to indexlist_url, notice: 'Plan was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "show" }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def deactivate
    @plan = Plan.find(params[:id])
    @plan.is_active = false
    @plan.save
    
    redirect_to indexlist_url
  end
end
