# frozen_string_literal: true

module SlashCommand
  module Commands
    class Now < Template
      HELP = <<-COMMAND_DESCRIPTION.strip_heredoc.freeze
        Shows spent time in current activity.
        usage: `/tt in [NOTE]`
      COMMAND_DESCRIPTION

      NO_CURRENT_ACTIVITY = "You are doing nothing right now, you lazy! :stuck_out_tongue_closed_eyes:!"

      SUCCESS_NOW = "You have been working for %{duration} on \"%{note}\". Whoa, I’m impressed!"

      def self.description
        "This command shows information about the current activity".freeze
      end

      def call
        response.result = result
      end

      private

      def result
        return HELP if help?
        return SUCCESS_NOW % {duration: user.running_activity.now, note: user.running_activity.note} if user.running_activity?

        NO_CURRENT_ACTIVITY
      end
    end
  end
end
