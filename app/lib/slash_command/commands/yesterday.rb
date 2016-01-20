# frozen_string_literal: true

module SlashCommand
  module Commands
    class Yesterday < Template
      NAME = "yesterday"
      DESC = "Display activities from yesterday."
      HELP = <<-HELP.strip_heredoc.freeze
        Show all yesterday activities.
        usage: `/tt yesterday`
      HELP

      NO_HISTORY_ACTIVITY = "You didn`t do anything yesterday, you lazy! :stuck_out_tongue_closed_eyes:"

      def call
        response.result = result
      end

      private

      def result
        return NO_HISTORY_ACTIVITY unless relation.present?

        show_time_entries_from_yesterday
      end

      def relation
        @relation ||= user.time_entries.order(date: :desc, start: :asc).where(date: Date.yesterday)
      end

      def show_time_entries_from_yesterday
        TimeEntries::Report.new(relation, data).build
      end
    end
  end
end
