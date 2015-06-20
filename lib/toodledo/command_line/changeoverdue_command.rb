
module Toodledo
  
  module CommandLine
    class ChangeOverdueCommand < BaseCommand
       def initialize(client)
	     super(client, 'changeoverdue', false)
         self.short_desc = "Sets overdue date to today for all such tasks"
         self.description = "Sets overdue date to today for all such tasks."
       end
       
      def execute(args)
	    print "cmd2"
		Toodledo.begin(client.logger) do |session|       
          line = args.join(' ')
		  client.changeoverdue_task(session, line)
        end
        
        return 0
      rescue ItemNotFoundError => e
        puts e.message
        return -1
      end
    end
  end
  
end