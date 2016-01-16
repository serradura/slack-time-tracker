# frozen_string_literal: true

module SlashCommand
  module Commands
    class Today < Template
      HELP = <<-COMMAND_DESCRIPTION.strip_heredoc.freeze
        Show all today activities.
        usage: `/tt today`
      COMMAND_DESCRIPTION

      NO_HISTORY_ACTIVITY = "You didn`t do anything today, you lazy! :stuck_out_tongue_closed_eyes:"

      def self.description
        "Display activities from today.".freeze
      end

      def call
        response.result = result
      end

      private

      def result
        return HELP if help?
        return NO_HISTORY_ACTIVITY unless relation.present?

        show_time_entries_from_today
      end

      def relation
        @relation ||= user.time_entries.order(date: :desc, start: :asc).where(date: Date.current)
      end

      def show_time_entries_from_today
        TimeEntriesReport.new(relation).build
      end
    end
  end
end
