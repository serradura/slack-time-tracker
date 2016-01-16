module SlashCommand
  class Payload
    attr_reader :raw, :user

    def initialize(params)
      @raw = params
      @user = User.find_or_update_by(raw)
    end

    def token
      @raw[:token]
    end
  end
end
