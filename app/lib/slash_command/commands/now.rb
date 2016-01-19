# frozen_string_literal: true

module SlashCommand
  module Commands
    class Now < Template
      DESC = "This command shows information about the current activity"

      HELP = <<-HELP.strip_heredoc.freeze
        Shows spent time in current activity.
        usage: `/tt in [NOTE]`
      HELP

      NOW_MESSAGE = "You have been working for %{duration} on \"%{note}\". Whoa, I’m impressed!"
      NO_CURRENT_ACTIVITY = "You are doing nothing right now, you lazy! :stuck_out_tongue_closed_eyes:!"

      def call
        response.result = result
      end

      private

      def result
        return HELP if help?
        return now_message if user.running_activity?

        NO_CURRENT_ACTIVITY
      end

      def now_message
        NOW_MESSAGE % {duration: user.running_activity.now, note: user.running_activity.note}
      end
    end
  end
end
