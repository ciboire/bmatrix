class PlansController < ApplicationController
  
  def dosisheets
    @files = Dir.glob('public/dsheets/*')
  end
  
  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.find(:all, :conditions => ['status <> ? AND is_active == ?', 'Upcoming', true], :order => :when_needs_image_review)
    @plans_upcoming = Plan.find(:all, :conditions => {:status => "Upcoming", :is_active => true})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @plans }
    end
  end
  
  def indexchoice
    @plans_needsMDContours = Plan.find(:all, :conditions => ['status == ? AND is_active == ?', 'Needs MD Contours', true], :order => :when_needs_image_review)
    @plans_needsApproval = Plan.find(:all, :conditions => ['status == ? AND is_active == ?', 'Needs Approval', true])
    
    @lkm_needsMDContours = 0
    @cks_needsMDContours = 0
    @other_needsMDContours = 0
    @overdue_needsMDContours = false
    @plans_needsMDContours.each do |plan|
      current = plan.when_needs_md_contours
      days = ((Time.now - current) / 24.hour).floor
      @overdue_needsMDContours = true if days > 1
      if plan.attending_md.casecmp("LKM") == 0
        @lkm_needsMDContours += 1
      elsif plan.attending_md.casecmp("CKS") == 0
        @cks_needsMDContours += 1
      else
        @other_needsMDContours += 1
      end  
    end
    
    @lkm_needsApproval = 0
    @cks_needsApproval = 0
    @other_needsApproval = 0
    @overdue_needsApproval = false
    @plans_needsApproval.each do |plan|
      current = plan.when_needs_approval
      days = ((Time.now - current) / 24.hour).floor
      @overdue_needsApproval = true if days > 1
      if plan.attending_md.casecmp("LKM") == 0
        @lkm_needsApproval += 1
      elsif plan.attending_md.casecmp("CKS") == 0
        @cks_needsApproval += 1
      else
        @other_needsApproval += 1
      end
    end
    
    @plans = Plan.find(:all, :conditions => ['status <> ? AND is_active == ?', 'Upcoming', true], :order => :when_needs_image_review)
    @plans_upcoming = Plan.find(:all, :conditions => {:status => "Upcoming", :is_active => true})
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @plans }
    end
  end
  
  def mdview
     @mdview_toggle = true
     @plans_needsMDContours = Plan.find(:all, :conditions => ['status == ? AND is_active == ?', 'Needs MD Contours', true], :order => :when_needs_image_review)
     @plans_needsApproval = Plan.find(:all, :conditions => ['status == ? AND is_active == ?', 'Needs Approval', true])

     @lkm_needsMDContours = 0
     @cks_needsMDContours = 0
     @other_needsMDContours = 0
     @overdue_needsMDContours = false
     @plans_needsMDContours.each do |plan|
       current = plan.when_needs_md_contours
       days = ((Time.now - current) / 24.hour).floor
       @overdue_needsMDContours = true if days > 1
       if plan.attending_md.casecmp("LKM") == 0
         @lkm_needsMDContours += 1
       elsif plan.attending_md.casecmp("CKS") == 0
         @cks_needsMDContours += 1
       else
         @other_needsMDContours += 1
       end  
     end

     @lkm_needsApproval = 0
     @cks_needsApproval = 0
     @other_needsApproval = 0
     @overdue_needsApproval = false
     @plans_needsApproval.each do |plan|
       current = plan.when_needs_approval
       days = ((Time.now - current) / 24.hour).floor
       @overdue_needsApproval = true if days > 1
       if plan.attending_md.casecmp("LKM") == 0
         @lkm_needsApproval += 1
       elsif plan.attending_md.casecmp("CKS") == 0
         @cks_needsApproval += 1
       else
         @other_needsApproval += 1
       end
     end

     @plans = Plan.find(:all, :conditions => ['status <> ? AND is_active == ?', 'Upcoming', true], :order => :when_needs_image_review)
     @plans_upcoming = Plan.find(:all, :conditions => {:status => "Upcoming", :is_active => true})

     respond_to do |format|
       format.html # index.html.erb
       format.json { render :json => @plans }
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
    
    def needsApproval
       @plans = Plan.find(:all, :conditions => ['status == ? AND is_active == ?', 'Needs Approval', true],
        :order => :when_needs_approval)

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
        
        @identifier = "#{@plan.created_at.year}" + "-" + "#{@plan.created_at.month}" + "-" + "#{@plan.created_at.day}" \
        + "-" + "#{@plan.created_at.hour}" + "-" + "#{@plan.created_at.min}" + "-"  + "#{@plan.created_at.sec}"
        system("cp -R /Users/brt/Sites/charts/template /Users/brt/Sites/charts/audit#{@identifier}")
        
        if params[:comment] != ""
          @comment = Comment.create(:content => params[:comment], :plan_id => @plan.id)
        end
        
        format.html { redirect_to indexchoice_url, notice: 'Plan was successfully created.' }
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
    if params[:status] != @plan.status
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
        format.html { redirect_to indexchoice_url }
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
    
    redirect_to indexchoice_url
  end
end
