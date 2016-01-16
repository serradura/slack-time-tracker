# frozen_string_literal: true

module SlashCommand
  class Response
    attr_writer :format, :result, :status

    InvalidResult = Class.new(Exception)

    def initialize(format: :text, result: "", status: 200)
      @format = format
      @result = result
      @status = status
    end

    def data
      {@format => @result, :status => @status}
    end
  end
end
