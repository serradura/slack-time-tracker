# frozen_string_literal: true

module SlashCommand
  module Commands
    class Now < Template
      NO_CURRENT_ACTIVITY = "You are doing nothing right now, you lazy! :stuck_out_tongue_closed_eyes:!"
      HELP = "This command shows information about the current activity"
      CURRENT_ACTIVITY_RUNNING = ""

      def call
        response.result = result
      end

      private

      def result
        return HELP if help?
        return parse_current_activity if has_current_activity?
        return NO_CURRENT_ACTIVITY 
      end

      def has_current_activity?
        user.has_activity_running?
      end

      def parse_current_activity
        current_activity = user.get_activity_running
        return (Time.current - current_activity.start).to_formatted_s(:time) + "  -  " + current_activity.note
      end

    end
  end
end
