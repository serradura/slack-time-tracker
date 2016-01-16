# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill < Template
      HELP = <<-COMMAND_DESCRIPTION.strip_heredoc.freeze
        Delete the current activity.
        usage: `/tt kill current`
      COMMAND_DESCRIPTION

      CURRENT_OPTION = "current"

      ACTIVITY_DELETED = "It's dead. (R.I.P :goberserk:)"

      COMMAND_NOT_VALID = "This command is not valid. Use `/tt kill current`"

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
        return execute_current_option if current_option?

        COMMAND_NOT_VALID
      end

      def current_option?
        data.tap(&:downcase!).include?(CURRENT_OPTION)
      end

      def execute_current_option
        if user.running_activity?
          user.running_activity.delete

          ACTIVITY_DELETED
        else
          ACTIVITY_NOT_RUNNING_MSG
        end
      end
    end
  end
end
