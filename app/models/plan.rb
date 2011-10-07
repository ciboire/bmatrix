class Plan < ActiveRecord::Base
  STATUS = ['Upcoming', 'Loaded', 'Needs Contours', 'Needs Plan', 'Needs Approval', 'Needs Finalizing', 'Finalized']
  ATTENDING = ['Lee McNeely, MD', 'Kelley Simpson, MD']
  
  def timestring
    current = Time.now
    case status
    when 'Loaded'
      current = when_loaded
    when 'Needs Contours'
      current = when_needs_contours
    when 'Needs Plan'
      current = when_needs_plan
    when 'Needs Approval'
      current = when_needs_approval
    when 'Needs Finalizing'
      current = when_needs_finalizing
    when 'Finalized'
      current = when_finalized
    end
      
    days = ((Time.now - current) / 24.hour).floor
    hours = (((Time.now - current) / 1.hour) % 24).floor
    color = "#999"
    color = "#c11b17" if days > 1
    color = "#c68e17" if days == 1
    
    ts = "<font style=\"color:#{color}\">"
    ts = ts + (days > 0 ? (days > 1 ? "#{days} days " : "#{days} day ") : "")
		ts = ts + (hours == 1 ? "#{hours} hr" : "#{hours} hrs")
		ts = ts + "</font>"
    
    return ts
  end
end
