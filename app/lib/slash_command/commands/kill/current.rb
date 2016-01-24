# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill
      class Current
        OPTION = /current/.freeze

        delegate :user, :message, to: :@handler

        def initialize(handler)
          @handler = handler
        end

        def invoked?
          @handler.invoke? OPTION
        end

        def call
          @handler.delete user.running_activity
        end
      end
    end
  end
end
