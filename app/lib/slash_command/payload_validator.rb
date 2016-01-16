module SlashCommand
  class PayloadValidator
    VALID_TOKEN = Rails.application.secrets.fetch(:slack_token).freeze

    def initialize(payload)
      @payload = payload
    end

    def ok?
      @payload.token == VALID_TOKEN
    end
  end
end
