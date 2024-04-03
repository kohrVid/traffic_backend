require 'rails_helper'

RSpec.describe Visit, type: :model do
  subject { build(:visit, user: user) }
  let(:ip_location) { double(:ip_location) }

  before do
    allow(IpLocation).to receive(:new)
      .and_return(ip_location)

    allow(ip_location).to receive(:coordinates)
      .and_return([])

    allow(ip_location).to receive(:vpn?).and_return(false)
  end

  describe 'validations' do
    describe ':user_id' do
      context 'when it is missing' do
        let(:user) { nil }

        before { subject.save }

        it { is_expected.to be_valid }
      end
    end
  end
end
