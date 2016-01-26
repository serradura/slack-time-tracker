require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:payload) { create(:slack_payload).tap {|pay| pay.text = payload_text } }
  let(:payload_text) { "edit" }
  let(:current_user) { User.last }
  let(:current_command) { SlashCommand::Commands::Edit }

  describe "'edit' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "there is a running activity" do
      let(:payload_note) { "test" }
      let(:payload_text) { "in #{payload_note}" }

      context "without a no note" do
        let(:payload_text) { "edit \t\n " }

        it "responds with not allowed empty note activity" do
          expected_message = current_command::EMPTY_NOTE_MSG

          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
        end
      end

      context "with a note" do
        let(:another_payload_note) { "test test" }

        before do
          payload.text = "edit #{another_payload_note}"
          post api_v1_commands_invoke_path, payload.to_h
        end

        it "responds saying the activity note was edited" do
          expected_message = current_command::ACTIVITY_EDITED

          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
          expect(current_user.running_activity.note).to be == another_payload_note
        end
      end

      context "when pass one id" do
        let(:payload_text) { "in #{first_payload_note}" }
        let(:first_time_entry) { current_user.time_entries.where(note: first_payload_note).first }
        let(:first_payload_note) { "first entry note" }
        let(:second_payload_note) { "second entry note" }
        let(:edited_payload_note) { "edited entry note" }

        before do
          payload.text = "in #{second_payload_note}"
          post api_v1_commands_invoke_path, payload.to_h

          payload.text = "edit #{payload_text_option} #{edited_payload_note}"
          post api_v1_commands_invoke_path, payload.to_h
        end

        context "with --id flag" do
          let(:payload_text_option) { "--id #{first_time_entry.id}" }

          it "responds saying the activity note was edited" do
            expected_message = current_command::ACTIVITY_EDITED

            expect(response).to have_http_status(200)
            expect(response.body).to be == expected_message

            expect(first_time_entry.reload.note).to be == edited_payload_note
            expect(current_user.running_activity.note).to be == second_payload_note
            expect(current_user.running_activity.note).to_not include payload_text_option
          end
        end

        context "with -i flag" do
          let(:payload_text_option) { "-i #{first_time_entry.id}" }

          it "responds saying the activity note was edited" do
            expected_message = current_command::ACTIVITY_EDITED

            expect(response).to have_http_status(200)
            expect(response.body).to be == expected_message

            expect(first_time_entry.reload.note).to be == edited_payload_note
            expect(current_user.running_activity.note).to be == second_payload_note
            expect(current_user.running_activity.note).to_not include payload_text_option
          end
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

      context "when pass one id" do
        let(:payload_text) { "in #{first_payload_note}" }
        let(:first_time_entry) { current_user.time_entries.where(note: first_payload_note).first }
        let(:first_payload_note) { "first entry note" }
        let(:edited_payload_note) { "edited entry note" }

        before do
          payload.text = "out"
          post api_v1_commands_invoke_path, payload.to_h

          payload.text = "edit #{payload_text_option} #{edited_payload_note}"
          post api_v1_commands_invoke_path, payload.to_h
        end

        context "with --id flag" do
          let(:payload_text_option) { "--id #{first_time_entry.id}" }

          it "responds saying the activity note was edited" do
            expected_message = current_command::ACTIVITY_EDITED

            expect(response).to have_http_status(200)
            expect(response.body).to be == expected_message

            expect(first_time_entry.reload.note).to be == edited_payload_note
            expect(current_user.running_activity).to be_blank
          end
        end

        context "with -i flag" do
          let(:payload_text_option) { "-i #{first_time_entry.id}" }

          it "responds saying the activity note was edited" do
            expected_message = current_command::ACTIVITY_EDITED

            expect(response).to have_http_status(200)
            expect(response.body).to be == expected_message

            expect(first_time_entry.reload.note).to be == edited_payload_note
            expect(current_user.running_activity).to be_blank
          end
        end
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
