# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill
      class ById
        OPTION = /(\-i|\-\-id)\s+(\d+)/.freeze

        delegate :user, :message, to: :@handler

        def initialize(handler)
          @handler = handler
        end

        def invoked?
          @handler.invoke? OPTION
        end

        def call
          @handler.delete time_entry
        end

        private

        def time_entry
          user.time_entries.find_by id: time_entry_id
        end

        def time_entry_id
          @handler.matches[2]
        end
      end
    end
  end
end
