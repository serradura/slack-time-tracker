# frozen_string_literal: true

module SlashCommand
  module Commands
    class Display < Template
      LIMIT = 50

      DESC = "Display #{LIMIT} entries information."

      HELP = <<-HELP.strip_heredoc.freeze
        Show all activities in history. Usage: `/tt display`
      HELP

      NO_HISTORY_ACTIVITY = "You didn`t do anything yet, you lazy! :stuck_out_tongue_closed_eyes:"

      def call
        response.result = result
      end

      private

      def result
        return HELP if help?
        return NO_HISTORY_ACTIVITY if user.time_entries.empty?

        display_time_entries
      end

      def display_time_entries
        relation = user.time_entries.order(date: :desc, start: :asc).limit(LIMIT)

        TimeEntries::Report.new(relation, data).build
      end
    end
  end
end
