require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:payload) { create(:slack_payload).tap {|pay| pay.text = payload_text } }
  let(:payload_text) { "resume" }
  let(:current_user) { User.last }
  let(:current_command) { SlashCommand::Commands::Resume }

  describe "'resume' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "without time entries" do
      it "Responds with a message saying: there is no time entries to resume." do
        expected_message = current_command::NO_TIME_ENTRIES

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
        expect(current_user.time_entries.count).to be_zero
      end
    end

    context "when there is time entries" do
      context "and the last was stopped" do
        let(:note) { "implementing the resume command" }
        let(:payload_text) { "in #{note}" }

        before do
          payload.text = "out"
          post api_v1_commands_invoke_path, payload.to_h

          payload.text = "resume"
          post api_v1_commands_invoke_path, payload.to_h
        end

        it "stop activity and responds with a message" do
          expected_message = current_command::ACTIVITY_RESTARTED

          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message

          expect(current_user.running_activity).to be_present
          expect(current_user.time_entries.where(note: note).count).to be == 2
        end
      end

      context "and one <id> was passed" do
        let(:note) { "first entry note" }
        let(:payload_text) { "in #{note}" }

        before do
          payload.text = "out"
          post api_v1_commands_invoke_path, payload.to_h

          payload.text = "in second entry note"
          post api_v1_commands_invoke_path, payload.to_h

          payload.text = "out"
          post api_v1_commands_invoke_path, payload.to_h

          payload.text = "resume --id #{current_user.time_entries.first.id}"
          post api_v1_commands_invoke_path, payload.to_h
        end

        it "stop activity and responds with a message" do
          expected_message = current_command::ACTIVITY_RESTARTED

          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message

          expect(current_user.running_activity).to be_present
          expect(current_user.running_activity.note).to be == note
        end
      end
    end

    context "and one <id> was passed (using the -i option)" do
      let(:note) { "first entry note" }
      let(:payload_text) { "in #{note}" }

      before do
        payload.text = "out"
        post api_v1_commands_invoke_path, payload.to_h

        payload.text = "in second entry note"
        post api_v1_commands_invoke_path, payload.to_h

        payload.text = "out"
        post api_v1_commands_invoke_path, payload.to_h

        payload.text = "resume -i #{current_user.time_entries.first.id}"
        post api_v1_commands_invoke_path, payload.to_h
      end

      it "stop activity and responds with a message" do
        expected_message = current_command::ACTIVITY_RESTARTED

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message

        expect(current_user.running_activity).to be_present
        expect(current_user.running_activity.note).to be == note
      end
    end

    context "help" do
      let(:payload_text) { "help resume" }

      it "responds with command instructions" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == current_command.help
      end
    end
  end
end
