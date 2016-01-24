require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:payload) { create(:slack_payload).tap {|pay| pay.text = payload_text } }
  let(:payload_text) { "out" }
  let(:current_user) { User.last }
  let(:current_command) { SlashCommand::Commands::Out }

  describe "'out' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "there is no running activity" do
      it "responds with a message that activity is not running" do
        expected_message = current_command::ACTIVITY_NOT_RUNNING_MSG

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
        expect(current_user.time_entries.count).to be_zero
      end
    end

    context "there is a running activity" do
      let(:payload_text) { "in test" }

      before do
        payload.text = "out \t\n "
        post api_v1_commands_invoke_path, payload.to_h
      end

      it "stop activity and responds with a message" do
        expected_message = current_command::STOP_SUCCESS_MSG

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
        expect(current_user.running_activity).to be_blank
      end
    end

    context "help" do
      let(:payload_text) { "help out" }

      it "responds with command instructions" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == current_command.help
      end
    end
  end
end
