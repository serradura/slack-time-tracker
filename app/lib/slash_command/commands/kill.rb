# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill < Template
      HELP = <<-COMMAND_DESCRIPTION.strip_heredoc.freeze
        Delete the current activity.
        usage: `/tt kill current`
      COMMAND_DESCRIPTION
      COMMAND_NOT_VALID = "This command is not valid. Use `/tt kill current`"
      ACTIVITY_DELETED = "It's dead. (R.I.P :goberserk:)"
      ACTIVITY_NOT_RUNNING_MSG = "You are doing nothing right now, you lazy! :stuck_out_tongue_closed_eyes:"

      def self.description
        HELP
      end

      def call
        response.result = result
      end

      private

      def result
        return HELP if help?
        return is_current? ? result_current : COMMAND_NOT_VALID
      end

      def result_current
        
      end

      def is_current?
        data.tap(&:downcase!) == "current"
      end

    end
  end
end