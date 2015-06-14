
module Toodledo
  module CommandLine    
    class TaskFormatter

      DUEDATE_BY = 0
      DUEDATE_ON = 1
      DUEDATE_AFTER = 2
      DUEDATE_OPTIONALLY = 3

      # Formats the task for a command line.
      def format(task)
        fancyp = readable_priority(task.priority)

        msg = "#{task.server_id} | #{fancyp} |"
  
        # TODO Only include [ ] if needed
		 imp  = "#{task.imp}"
		 msg += " %3.3s |" % imp
		 
		 ttl =  "#{task.title}"
		 msg += " %-45.45s |" % ttl
		
		
		if (task.duedate != nil)
          fmt = '%d/%m/%Y'
          msg += " #{readable_duedatemodifier(task.duedatemodifier)}#{task.duedate.strftime(fmt)} |"
		else
		  msg += "            |"
        end
		  
		
		if (task.folder != Folder::NO_FOLDER)
		  fold = "#{task.folder.name}"
          msg += " %-8.8s |" % fold
        else
		  msg += "          |"
		end
		
        if (task.context != Context::NO_CONTEXT)
		  ctx = "#{task.context.name}"
          msg += " %-6.6s |" % ctx
		else
		  msg += "        |"
        end
  
        #if (task.goal != Goal::NO_GOAL)
        #  msg += " ^[#{task.goal.name}]"
        #end
  
        msg += " #{readable_repeat(task.repeat)} |"
		
        
        
        if (task.startdate != nil)
          fmt = '%m/%d/%Y'
          msg += " startdate[#{task.startdate.strftime(fmt)}]"
        end
        
        if (task.status != Status::NONE)
          msg += " status[#{readable_status(task.status)}]"
        end
        
        if (task.star)
          msg += " starred"
        end
  
        if (task.tag != nil)
          msg += " %[#{task.tag}]"
        end
        
        if (task.parent_id != nil)
          msg += " parent[#{task.parent.title}]"
        end
  
        if (task.length != nil)
          msg += " length[#{task.length}]"
        end
        
        if (task.timer != nil)
          msg += " timer[#{task.timer}]"
        end
        
        if (task.num_children != nil && task.num_children > 0)
          msg += " children[#{task.num_children}]"
        end
        
              
        #if (task.note != nil)
        #  msg += "\n      #{task.note}"
        #end
		
		case task.priority
		  when Priority::TOP
            return red(msg)
          when Priority::HIGH
            return pink(msg)
          when Priority::MEDIUM
            return yellow(msg)
          when Priority::LOW
            return green(msg)
          when Priority::NEGATIVE
            return lightblue(msg)
          else
            return msg
		end
		
		
        return msg
      end
      
      # TODO Refactor using symbols -- so much simpler to convert
      def readable_priority(priority)
        case priority
          when Priority::TOP
            return 'top     '
          when Priority::HIGH
            return 'high    '
          when Priority::MEDIUM
            return 'medium  '
          when Priority::LOW
            return 'low     '
          when Priority::NEGATIVE
            return 'negative'
          else
            return '        '
        end
      end

      def readable_duedatemodifier(duedate_modifier)
        # The modifier is passed in as [0..3] but may come back as
        # <duedate modifier='?'>2011-06-30</duedate>
        case duedate_modifier
          when DUEDATE_BY then
            return ''
          when DUEDATE_ON then
            return '='
          when DUEDATE_AFTER then
            return '>'
          when DUEDATE_OPTIONALLY then
            return '?'
          else
            return duedate_modifier
        end
      end
      
      #
      # Returns a string matching the numeric repeat code.
      #
      def readable_repeat(repeat)
        case repeat
        when Repeat::NONE
          "         "
        when Repeat::WEEKLY
          "weekly   "
        when Repeat::MONTHLY
          "monthly  "
        when Repeat::YEARLY
          "yearly   "
        when Repeat::DAILY
          "daily    "
        when Repeat::BIWEEKLY
          "biweekly "
        when Repeat::BIMONTHLY
          "bimonthly"
        when Repeat::SEMIANNUALLY
          "6mthly   "
        when Repeat::QUARTERLY
          "quarterly"
        else
          ''
        end
      end
      
      #
      # Return a readable status given the numeric code.
      #
      def readable_status(status)
        case status
        when Status::NONE
          'none     '
        when Status::NEXT_ACTION
          'Nxt Act  '
        when Status::ACTIVE
          'Active   '
        when Status::PLANNING
          'Planning '
        when Status::DELEGATED
          'Delegated'
        when Status::WAITING
          'Waiting  '
        when Status::HOLD
          'Hold     '
        when Status::POSTPONED
          'Postponed'
        when Status::SOMEDAY
          'Someday  '
        when Status::CANCELLED
          'Cancelled'
        when Status::REFERENCE
          'Reference'
        end
      end
	  
	  def colorize(text, color_code)
		"\e[#{color_code}m#{text}\e[0m"
	  end

	  def red(text); colorize(text, 31); end
      def green(text); colorize(text, 32); end
	  def yellow(text); colorize(text, 33); end
      def blue(text); colorize(text, 34); end
	  def pink(text); colorize(text, 35); end
      def lightblue(text); colorize(text, 36); end
    end
  end
end