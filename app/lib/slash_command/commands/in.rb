# frozen_string_literal: true

module SlashCommand
  module Commands
    class In < Template
      NAME = "in"
      DESC = "Start the timer for a new activity."
      HELP = <<-HELP.strip_heredoc.freeze
        Usage: `/tt` in [NOTE] [--at TIME]
        -a, --at <time:qs> Use this time instead of now.

        Examples:
        `/tt in -a "5 minutes ago"`
        `/tt in --at '17:00'`
      HELP

      EMPTY_NOTE_MSG = "You need a note to this activity!"
      NEW_ACTIVITY_CREATED = "You have just started working on a new activity. Keep going."
      STOPED_LAST_CREATED_NEW = "The previous activity was stopped and the next one just started."

      DELIMITERS = "\"'“”‘’`"
      AT_PATTERN = /(\-a|([-]{2}|—)at)\s?[#{DELIMITERS}](.+)[#{DELIMITERS}]/.freeze

      def call
        response.result = data.blank? ? EMPTY_NOTE_MSG : create_time_entry
      end

      private

      def at_option
        @at_option ||= data.match(AT_PATTERN)
      end

      def start_time
        at_option.present? ? Chronic.parse(at_option[3]) : Time.current
      end

      def note
        at_option.present? ? note_without_at_option : data
      end

      def note_without_at_option
        data.sub!(at_option[0], "").tap(&:strip!)
      end

      def create_time_entry
        message = NEW_ACTIVITY_CREATED
        message = STOPED_LAST_CREATED_NEW if user.stop_running_activity

        user.build_time_entry(start: start_time, note: note).tap(&:save)

        message
      end
    end
  end
end
