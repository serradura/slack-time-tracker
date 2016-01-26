# frozen_string_literal: true

module SlashCommand
  module Commands
    class Edit < Template
      NAME = "edit"
      DESC = "Alter an entry's note. Defaults to the running entry."
      HELP = <<-HELP.strip_heredoc.freeze
        Usage: `/tt` edit [NOTE] [--id ID]
        -i, --id <id:i> Alter entry with id <id> instead of the running entry

        Examples:
        `/tt edit update current entry note.`
        `/tt edit -i 99 update a specific entry note.`
      HELP

      EMPTY_NOTE_MSG = "You need a note to this update!"
      ACTIVITY_EDITED = "The activity was updated!"
      ACTIVITY_NOT_RUNNING_MSG = "Hey, what's going on? Let's start an activity first! (e.g: `/tt in <NOTE>`)".freeze

      ID_PATTERN = /(\-i|\-\-id)\s+(\d+)/.freeze

      def call
        response.result = result
      end

      private

      def result
        return EMPTY_NOTE_MSG if data.blank?

        time_entry = find_time_entry

        return ACTIVITY_NOT_RUNNING_MSG if time_entry.blank?

        update time_entry
      end

      def id_option
        @id_option ||= data.match(ID_PATTERN)
      end

      def find_time_entry
        if id_option.present?
          user.time_entries.find_by id: id_option[2]
        else
          user.running_activity
        end
      end

      def update(time_entry)
        note = id_option.present? ? data.sub!(id_option[0], "").tap(&:strip!) : data

        time_entry.update_attribute(:note, note)

        ACTIVITY_EDITED
      end
    end
  end
end
