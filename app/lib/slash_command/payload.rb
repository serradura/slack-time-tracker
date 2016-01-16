module SlashCommand
  class Payload
    User = Struct.new(:name, :id)

    attr_reader :raw, :user

    def initialize(params)
      @raw  = params
      @user = User.new(raw[:user_name], raw[:user_id])
    end

    def token
      @raw[:token]
    end

    def text
      @raw[:text]
    end
  end
end
