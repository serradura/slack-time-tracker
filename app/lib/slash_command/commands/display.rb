# frozen_string_literal: true

module SlashCommand
  module Commands
    class Display < Template
      HELP = <<-COMMAND_DESCRIPTION.strip_heredoc.freeze
        Show all activities in history. Usage: `/tt display`
      COMMAND_DESCRIPTION

      LIMIT = 50

      NO_HISTORY_ACTIVITY = "You didn`t do anything yet, you lazy! :stuck_out_tongue_closed_eyes:"

      def self.description
        "Display #{LIMIT} entries information.".freeze
      end

      def call
        response.result = result
      end

      private

      def result
        return HELP if help?
        return NO_HISTORY_ACTIVITY unless user.time_entries.exists?

        show_recent_time_entries
      end

      def show_recent_time_entries
        relation = user.time_entries.order(date: :desc, start: :asc).limit(LIMIT)

        TimeEntriesReport.new(relation).build
      end
    end
  end
end
