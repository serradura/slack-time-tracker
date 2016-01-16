# frozen_string_literal: true

module SlashCommand
  module Commands
    class Out < Template
      HELP = "This command will stop the last activity."
      STOP_SUCCESS_MSG = "You just took a break. Move on! :simle:"

      def call
        response.result = result
      end

      private

      def result
        binding.pry
        return HELP if help?
        result_with_activity
      end

      def result_with_activity
        user.time_entries.create(date: Date.current, start: Time.current, note: data)

        NEW_ACTIVITY_CREATED
      end
    end
  end
end
