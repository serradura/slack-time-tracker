# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill
      class Current
        OPTION = "current"

        delegate :user, :message, to: :@handler

        def initialize(handler)
          @handler = handler
        end

        def invoked?
          @handler.invoke? OPTION
        end

        def call
          @handler.delete_when user.running_activity? do
            user.running_activity.delete
          end
        end
      end
    end
  end
end
