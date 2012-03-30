class Plan < ActiveRecord::Base
  has_many :comments
  STATUS = ['Upcoming', 'Loaded', 'Needs Contours', 'Needs Plan', 'Needs Approval', 'Needs Finalizing', 'Finalized']
  ATTENDING = ['Lee McNeely, MD', 'Kelley Simpson, MD', 'Brian Fuller, MD', 'Elizabeth Ceilley, MD']
  RECIPIENTS = ['brian.thorndyke@coloradocyberknife.com', 'kelley.simpson@coloradocyberknife.com', 
    'lee.mcneely@coloradocyberknife.com', 'ruby.givens@coloradocyberknife.com', 'melinda.macintyre@coloradocyberknife.com']
  
  def timestring
    current = Time.now
    case status
    when 'Needs Records Review'
      current = when_needs_image_review
    when 'Waiting for Consult'
      current = when_waiting_for_consult
    when 'Waiting for Setup'
      current = when_needs_setup
    when 'Needs MultiPlan Prep'
      current = when_needs_preparation  
    when 'Needs MD Contours'
      current = when_needs_md_contours
    when 'Needs Plan'
      current = when_needs_plan
    when 'Needs Approval'
      current = when_needs_approval   
    when 'Needs Finalizing'
      current = when_needs_finalizing
    when 'Ready for Treatment'
      current = when_ready_for_treatment
    when 'In Treatment'
      current = when_in_treatment
    when 'Finished Treatment'
      current = when_finished_treatment
    end
      
    days = ((Time.now - current) / 24.hour).floor
    hours = (((Time.now - current) / 1.hour) % 24).floor
    color = "#999"
    color = "#c11b17" if days > 1
    color = "#c69e17" if days == 1
    color = "#00aa00" if status == 'In Treatment'
    color = "#fff" if status == 'Finished Treatment'
    
    ts = "<font style=\"color:#{color}\">"
    ts = ts + (days > 0 ? (days > 1 ? "#{days} days " : "#{days} day ") : "")
		ts = ts + (hours == 1 ? "#{hours} hr" : "#{hours} hrs")
		ts = ts + "</font>"
    
    return ts
  end
end
