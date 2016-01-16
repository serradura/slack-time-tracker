module SlashCommand
  class Payload
    attr_reader :raw, :user

    def initialize(params)
      @raw  = params
      @user = find_user
    end

    def token
      @raw[:token]
    end

    def text
      @raw[:text]
    end

    def find_user
      User.find_or_update_by raw
    end
  end
end
