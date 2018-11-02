require 'rails_helper'

RSpec.describe LoadOrganizationsJob, type: :job do
  let(:key) { 123 }
  subject(:job) { described_class.perform_later(key) }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class).with(key).on_queue('default')
  end
end
