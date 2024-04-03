require 'rails_helper'

RSpec.describe IpInfo, type: :model do
  subject { create(:ip_info) }
  let(:ip_address) { '' }
  let(:ip_location) { double(:ip_location) }

  before do
    allow(IpLocation).to receive(:new)
      .and_return(ip_location)

    allow(ip_location).to receive(:coordinates)
      .and_return([])

    allow(ip_location).to receive(:vpn?).and_return(false)
  end

  describe 'validations' do
    describe ':address' do
      let(:new_ip) do
        IpInfo.new(address: ip_address)
      end

      context 'when it is missing or blank' do
        before { new_ip.save}

        it 'is invalid' do
          expect(new_ip).not_to be_valid
        end

        it 'raises the correct error message' do
          expect(
            new_ip.errors.messages[:address]
          ).to include("can't be blank")
        end
      end

      context 'when a record with the same address already exists' do
        let(:ip_address) { subject.address }

        before do
          subject
          new_ip.save
        end

        it 'is invalid' do
          expect(new_ip).not_to be_valid
        end

        it 'raises the correct error message' do
          expect(
            new_ip.errors.messages[:address]
          ).to include("has already been taken")
        end
      end
    end
  end

  describe '#loopback?' do
    subject { create(:ip_info, address: ip_address).loopback? }

    context 'when the loopback address is set' do
      let(:ip_address) { '127.0.0.1' }

      it { is_expected.to eq true }
    end

    context 'when a bogon address is set' do
      let(:ip_address) { '::1' }

      it { is_expected.to eq true }
    end

    context 'when a real IP address is set' do
      let(:ip_address) { '213.152.176.135' }

      it { is_expected.to eq false }
    end
  end
end
