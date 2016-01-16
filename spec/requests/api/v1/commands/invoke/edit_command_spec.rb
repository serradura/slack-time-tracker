require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "'edit' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    let(:current_user) { User.last }

    context "there is a running activity" do

      NOTE = 'test'

      let(:payload) do
        create(:slack_in_command_payload).tap {|pay| pay.text = "in #{NOTE}" }
      end

      context "there is note" do
        NOTE_CHANGE = 'test2'
        before do
          payload.text = "edit #{NOTE_CHANGE}"
          post api_v1_commands_invoke_path, payload.to_h
        end

        it "responds with not allowed empty note activity" do
          expected_message = SlashCommand::Commands::Edit::ACTIVITY_EDITED

          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
          expect(current_user.running_activity.note).to be == NOTE_CHANGE
        end
      end


      context "there is no note" do
        before do
          payload.text = "edit#{[' ', "\n", "\t"].sample * rand(20)}"
          post api_v1_commands_invoke_path, payload.to_h
        end

        it "responds with not allowed empty note activity" do
          expected_message = SlashCommand::Commands::Edit::EMPTY_NOTE_MSG

          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
          expect(current_user.running_activity.note).to be == NOTE
        end
      end
    end

    context "there is no running activity" do
      
      let(:payload) do
        create(:slack_edit_command_payload)
      end

      it "responds with a message that activity is not running" do
        expected_message = SlashCommand::Commands::Edit::ACTIVITY_NOT_RUNNING_MSG
        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end


    context "help" do
      let(:payload) do
        create(:slack_edit_command_payload).tap {|pay| pay.text = "edit help" }
      end

      it "responds with command instructions" do
        expected_message = SlashCommand::Commands::Edit::HELP
        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end
  end
end
