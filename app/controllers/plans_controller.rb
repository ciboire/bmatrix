class PlansController < ApplicationController
  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.find(:all, :conditions => ['status <> ? AND is_active == ?', 'Upcoming', true], :order => :when_loaded)
    @plans_upcoming = Plan.find(:all, :conditions => {:status => "Upcoming", :is_active => true})

    respond_to do |format|
      format.html # index.html.erb
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
    @plan.maillist = "brian.thorndyke@coloradocyberknife.com, ruby.givens@coloradocyberknife.com, kelley.simpson@coloradocyberknife.com, lee.mcneely@coloradocyberknife.com"

    respond_to do |format|
      if @plan.save
        @history = History.create(:action => "new", :reference_id => @plan.id)
        @message_short = "Upcoming..."
        @message_long = "Patient / plan is upcoming.  Stay tuned!"
        UserMailer.status_email(@plan, @message_short, @message_long).deliver
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
    @message_short = ""
    @message_long = ""
    case params[:status]
    when 'Loaded'
      @plan.status = 'Loaded'
      @plan.when_loaded = Time.now
      @history = History.create(:action => "loaded", :reference_id => @plan.id)
      @message_short = "Scans loaded"
      @message_long = "Scans have been uploaded into CDMS."
    when 'Needs Contours'
      @plan.status = 'Needs Contours'
      @plan.when_needs_contours = Time.now
      @history = History.create(:action => "needs contours", :reference_id => @plan.id)
      @message_short = "Ready for contouring"
      @message_long = "Scans are ready for contouring."
    when 'Needs Plan'
      @prev_status = @plan.status
      @plan.status = 'Needs Plan'
      @plan.when_needs_plan = Time.now
      @history = History.create(:action => "needs plan", :reference_id => @plan.id)
      if @prev_status == 'Needs Approval'
        @message_short = "Requires replanning"
        @message_long = "Plan encountered problems and requires replanning."
      else
        @message_short = "Ready for planning"
        @message_long = "Contours are finished and ready for planning."
      end
    when 'Needs Approval'
      @prev_status = @plan.status
      @plan.status = 'Needs Approval'
      @plan.when_needs_approval = Time.now
      @history = History.create(:action => "needs approval", :reference_id=> @plan.id)
      if @prev_status == 'Needs Finalizing'
        @message_short = 'Needs re-approval'
        @message_long = 'Finalizing revealed problems and plan needs re-approval.'
      else
        @message_short = "Ready for review"
        @message_long = "Plan is finished and ready for review / approval."
      end
    when 'Needs Finalizing'
      @plan.status = 'Needs Finalizing'
      @plan.when_needs_finalizing = Time.now
      @history = History.create(:action => "needs finalizing", :reference_id => @plan.id)
      @message_short = "Approved"
      @message_long = "Plan is approved and reday for finalizing."
    when 'Finalized'
      @plan.status = 'Finalized'
      @plan.when_finalized = Time.now
      @history = History.create(:action => "finalized", :reference_id => @plan.id)
      @message_short = "Finalized"
      @message_long = "Plan is finalized and ready for delivery."
    end
    @plan.save
    
    if params[:comment] != ""
      @comment = Comment.create(:content => params[:comment], :plan_id => @plan.id)
      @history = History.create(:action => "comment", :reference_id => @comment.id)
      @message_long = @message_long + "<p>#{@comment.content}</p>"
    end
    
    if @message_long != ""
      UserMailer.status_email(@plan, @message_short, @message_long).deliver
    end
      
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
  
  def deactivate
    @plan = Plan.find(params[:id])
    @plan.is_active = false
    @plan.save
    
    @history = History.create(:action => "deactivate", :reference_id => @plan.id)
    
    redirect_to plans_url
  end
end
