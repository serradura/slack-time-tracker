# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill < Template
      NAME = "kill"
      DESC = "Delete a timesheet entry."
      HELP = <<-HELP.strip_heredoc.freeze
        Delete the current activity.
        usage: `/tt kill current`
      HELP

      INVALID_COMMAND = "This command is not valid. Check `/tt help kill`"

      def call
        response.result = result
      end

      private

      def result
        current = Current.new(self)

        return current.call if current.invoked?

        INVALID_COMMAND
      end
    end
  end
end
