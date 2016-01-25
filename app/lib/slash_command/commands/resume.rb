# frozen_string_literal: true

module SlashCommand
  module Commands
    class Resume < Template
      NAME = "resume"
      DESC = "Start the timer for an entry. Defaults to the last entry."
      HELP = <<-HELP.strip_heredoc.freeze
        Usage /tt resume [--id ID]
        -i, --id <ID>\tResume entry with id <id> instead of the last entry.
      HELP

      NO_TIME_ENTRIES = "There’s no time entries. Please, use `/tt in NOTE` to start the timer."
      ACTIVITY_RESTARTED = "You have just started working on a new activity. Keep going."

      ID_PATTERN = /(\-i|\-\-id)\s+(\d+)/.freeze

      def call
        response.result = result
      end

      private

      def result
        time_entry = find_time_entry

        return NO_TIME_ENTRIES if time_entry.blank?

        return ACTIVITY_RESTARTED if create(time_entry).persisted?
      end

      def find_time_entry
        id_data = data.match(ID_PATTERN)

        if id_data.present?
          user.time_entries.find_by id: id_data[2]
        else
          user.time_entries.last
        end
      end

      def create(time_entry)
        user.build_time_entry(note: time_entry.note).tap(&:save)
      end
    end
  end
end
