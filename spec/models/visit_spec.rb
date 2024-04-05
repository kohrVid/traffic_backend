require 'rails_helper'

RSpec.describe Visit, type: :model do
  subject { build(:visit, :with_ip_info, user: user) }
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

  describe '.for_page' do
    subject { Visit.for_page(page1.id) }
    let(:user) { create(:user) }
    let(:ip_info) { create(:ip_info) }
    let(:page1) { create(:page) }
    let(:page2) { create(:page, name: 'contact') }
    let(:visit1) { create(:visit, page: page1, ip_info: ip_info, user: user) }
    let(:visit2) { create(:visit, page: page1, ip_info: ip_info, user: user) }
    let(:visit3) { create(:visit, page: page2, ip_info: ip_info, user: user) }

    before do
      visit1
      visit2
      visit3
    end

    it 'returns visits for a given page' do
      expect(subject).to match_array([visit1, visit2])
    end

    it 'does not return visits for other pages' do
      expect(subject).not_to include(visit3)
    end
  end

  describe '.visited_between' do
    subject { Visit.visited_between(start_time, end_time) }
    let(:start_time) { Time.local(2024, 4, 3, 14, 50) }
    let(:end_time) { Time.local(2024, 4, 5, 14, 50) }
    let(:ip_info) { create(:ip_info) }

    let(:visit1) do
      create(
        :visit,
        ip_info: ip_info,
        visited_at: Time.local(2024, 4, 3, 15)
      )
    end

    let(:visit2) do
      create(
        :visit,
        ip_info: ip_info,
        visited_at: Time.local(2024, 4, 4, 2, 50)
      )
    end

    let(:visit3) do
      create(
        :visit,
        ip_info: ip_info,
        visited_at: Time.local(2024, 4, 3, 14, 49)
      )
    end

    before do
      visit1
      visit2
      visit3
    end

    it 'returns visits for a given page' do
      expect(subject).to match_array([visit1, visit2])
    end

    it 'does not return visits for other pages' do
      expect(subject).not_to include(visit3)
    end
  end
end
