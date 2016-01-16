require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "'in' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "there is no running activity" do
      let(:current_user) { User.last }

      let(:payload) do
        create(:slack_in_command_payload)
      end

      it "responds with a new activity entry message" do
        expected_message = SlashCommand::Commands::In::NEW_ACTIVITY_CREATED

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
        expect(current_user.time_entries.count).to_not be_zero
      end
    end

    context "there is no note" do
      let(:payload) do
        create(:slack_in_command_payload).tap {|pay| pay.text = "in#{[' ', "\n", "\t"].sample * rand(20)}" }
      end

      it "responds with not allowed empty note activity" do
        expected_message = SlashCommand::Commands::In::EMPTY_NOTE_MSG

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end

    context "help" do
      let(:payload) do
        create(:slack_in_command_payload).tap {|pay| pay.text = "in help" }
      end

      it "responds with command instructions" do
        expected_message = SlashCommand::Commands::In::HELP

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end
  end
end
