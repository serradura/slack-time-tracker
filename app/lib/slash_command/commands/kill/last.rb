# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill
      class Last
        OPTION = /last/.freeze

        delegate :user, :message, to: :@handler

        def initialize(handler)
          @handler = handler
          @current ||= Current.new(handler)
        end

        def invoked?
          @handler.invoke? OPTION
        end

        def call
          @current.call

          @handler.delete last_time_entry
        end

        private

        def last_time_entry
          user.time_entries.last
        end
      end
    end
  end
end
