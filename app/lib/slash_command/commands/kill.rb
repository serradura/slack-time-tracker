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

      STRATEGIES = [Current, Last, ById].freeze

      INVALID_COMMAND = "This command is not valid. Check `/tt help kill`"

      def call
        response.result = result
      end

      private

      def result
        strategy = find_strategy

        return strategy.tap(&:call).message if strategy.present?

        INVALID_COMMAND
      end

      def find_strategy
        handler = Handler.new(self)
        strategies = STRATEGIES.map {|strategy| strategy.new(handler) }
        strategies.find(&:invoked?)
      end
    end
  end
end
