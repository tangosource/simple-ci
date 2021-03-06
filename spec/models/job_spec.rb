require 'spec_helper'

describe Job, 'validations' do
  it { should validate_presence_of(:session_id) }
  it { should validate_presence_of(:github_url) }
end

describe Job, 'callbacks' do
  let(:job) { job = Job.new(session_id: Faker::Lorem.sentence, github_url: Faker::Internet.url) }
  it 'triggers a background job after saving the record into the database' do
    expect(job).to receive(:trigger_job)
    job.save
  end

  it 'publishes the change trough the websocket' do
    expect(job).to receive(:publish)
    job.save
  end

end

describe Job, 'Publish to websocket' do
  let(:job) { Fabricate :job }

  it 'Publishes the change in the channel' do
    expect {
      job.publish(
        'some_event',
        message: Faker::Lorem.sentence
      )
    }.to be_true
  end

end
