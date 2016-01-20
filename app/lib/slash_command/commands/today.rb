# frozen_string_literal: true

module SlashCommand
  module Commands
    class Today < Template
      NAME = "today"
      DESC = "Display activities from today."

      HELP = <<-HELP.strip_heredoc.freeze
        Show all today activities.
        usage: `/tt today`
      HELP

      NO_HISTORY_ACTIVITY = "You didn`t do anything today, you lazy! :stuck_out_tongue_closed_eyes:"

      def call
        response.result = result
      end

      private

      def result
        return help if help?
        return NO_HISTORY_ACTIVITY unless relation.present?

        show_time_entries_from_today
      end

      def relation
        @relation ||= user.time_entries.order(date: :desc, start: :asc).where(date: Date.current)
      end

      def show_time_entries_from_today
        TimeEntries::Report.new(relation, data).build
      end
    end
  end
end
