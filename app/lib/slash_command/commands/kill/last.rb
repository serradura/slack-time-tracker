# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill
      class Last
        OPTION = "last"

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

          @handler.delete_when last_activity.present? do
            last_activity.delete
          end
        end

        private

        def last_activity
          @last_activity ||= user.time_entries.last
        end
      end
    end
  end
end
