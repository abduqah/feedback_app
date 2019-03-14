require 'rails_helper'
RSpec.describe CreateWorker, type: :worker do
  describe '#perform' do
    let(:worker) { CreateWorker.new() }

    context 'with valid attributes' do
      let(:feedback_attributes) { {
        company_token: SecureRandom.hex(9),
        number: 1,
        priority: 'minor'
      } }
      
    let(:state_attributes) {
      {
        device: 'OnePlus 6T',
        os: 'android 9',
        memory: 8192,
        storage: 12902
      }
    }

    it 'succesfully creates a feedback with connected state' do
      expect {
        worker.perform(feedback_attributes, state_attributes)
      }.to change { Feedback.count }.by(1)
        .and change { State.count }.by(1)
    end
  end

  context 'with invalid feedback attributes' do
    let(:feedback_attributes) { {
      priority: 'minor'
    } }

    let(:state_attributes) {
      {
        device: 'OnePlus 6T',
        os: 'Android 9',
        memory: 8192,
        storage: 129024
      }
    }

  it 'rolls back feedback and state creation' do
      expect do
        begin
          worker.perform(feedback_attributes, state_attributes)
        rescue => exception
        end
      end.to_not change { Feedback.count }

        expect do
          begin
            worker.perform(feedback_attributes, state_attributes)
          rescue => exception
          end
        end.to_not change { State.count }
      end

      it 'raises a record invalid error' do
        expect do
          worker.perform(feedback_attributes, state_attributes)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
