# frozen_string_literal: true

module SlashCommand
  module Commands
    class Edit < Template
      NAME = "edit"
      DESC = "This command will update the current activity note."
      HELP = <<-HELP.strip_heredoc.freeze
        Update the note of the current activity.
        usage: `/tt edit [NOTE]`
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

      def id_data
        @id_data ||= data.match(ID_PATTERN)
      end

      def find_time_entry
        if id_data.present?
          user.time_entries.find_by id: id_data[2]
        else
          user.running_activity
        end
      end

      def update(time_entry)
        note = id_data.present? ? data.sub!(id_data[0], "").tap(&:strip!) : data

        time_entry.update_attribute(:note, note)

        ACTIVITY_EDITED
      end
    end
  end
end
