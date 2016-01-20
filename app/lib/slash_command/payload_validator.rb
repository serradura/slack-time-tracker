# frozen_string_literal: true

module SlashCommand
  class PayloadValidator
    VALID_TOKEN = Rails.application.secrets.fetch(:slack_token).freeze
    TOKEN_ERROR = "Invalid slack token :astonished:"
    ERROR_RESPONSE = Response.new(result: TOKEN_ERROR)

    attr_reader :error_response

    def initialize(payload)
      @payload = payload
      @error_response = ERROR_RESPONSE
    end

    def error?
      @payload.token != VALID_TOKEN
    end
  end
end
