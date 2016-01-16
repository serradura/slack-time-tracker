FactoryGirl.define do
  ID_GENERATOR = -> { Faker::Lorem.characters(9).upcase }
  HOOK_URL_TEMPLATE = "https://hooks.slack.com/commands/%{team_id}/18452276771/kfN7zShxWmHC5uLfLqJ4EeWo".freeze

  factory :slack_payload, class: OpenStruct do
    command "/tt".freeze
    token { Rails.application.secrets.fetch(:slack_token) }
    team_id(&ID_GENERATOR)
    team_domain { Faker::Internet.slug }
    channel_id(&ID_GENERATOR)
    channel_name { Faker::Hipster.word }
    user_id(&ID_GENERATOR)
    user_name { Faker::Internet.user_name(nil, ["."]) }
    text { Faker::Lorem.word }
    response_url {|payload| HOOK_URL_TEMPLATE % {team_id: payload.team_id} }
  end

  factory :slack_invalid_token_payload, parent: :slack_payload do
    token { Faker::Lorem.characters(24) }
  end

  factory :slack_when_command_payload, parent: :slack_payload do
    text { "when" }
  end

  factory :slack_what_command_payload, parent: :slack_payload do
    text { "what" }
  end

  factory :slack_unknown_command_payload, parent: :slack_payload do
    text { Faker::Lorem.characters(5) }
  end

  factory :slack_in_command_payload, parent: :slack_payload do
    text { "in #{Faker::Hacker.say_something_smart}" }
  end

  factory :slack_now_command_payload, parent: :slack_payload do
    text { "now" }
  end

  factory :slack_out_command_payload, parent: :slack_payload do
    text { "out" }
  end

  factory :slack_help_command_payload, parent: :slack_payload do
    text { "help" }
  end
end
