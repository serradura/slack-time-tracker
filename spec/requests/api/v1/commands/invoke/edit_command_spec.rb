require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:payload) { create(:slack_payload).tap {|pay| pay.text = payload_text } }
  let(:payload_text) { "edit" }
  let(:current_command) { SlashCommand::Commands::Edit }

  describe "'edit' command" do
    let(:current_user) { User.last }

    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "there is a running activity" do
      let(:payload_note) { "test" }
      let(:payload_text) { "in #{payload_note}" }

      context "there is note" do
        let(:another_payload_note) { "test test" }

        before do
          payload.text = "edit #{another_payload_note}"
          post api_v1_commands_invoke_path, payload.to_h
        end

        it "responds with not allowed empty note activity" do
          expected_message = current_command::ACTIVITY_EDITED

          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
          expect(current_user.running_activity.note).to be == another_payload_note
        end
      end

      context "there is no note" do
        let(:payload_text) { "edit \t\n " }

        it "responds with not allowed empty note activity" do
          expected_message = current_command::EMPTY_NOTE_MSG

          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
        end
      end
    end

    context "there is no running activity" do
      let(:payload_text) { "edit foo" }

      it "responds with a message that activity is not running" do
        expected_message = current_command::ACTIVITY_NOT_RUNNING_MSG
        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end

    context "help" do
      let(:payload_text) { "help edit" }

      it "responds with command instructions" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == current_command.help
      end
    end
  end
end
