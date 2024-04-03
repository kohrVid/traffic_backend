require 'rails_helper'

RSpec.describe IpInfo, type: :model do
  subject { create(:ip_info) }
  let(:ip_address) { '' }
  let(:ip_location) { double(:ip_location) }
  let(:lat) { 50 }
  let(:lon) { 4 }

  before do
    allow(IpLocation).to receive(:new)
      .and_return(ip_location)

    allow(ip_location).to receive(:coordinates)
      .and_return([lat, lon])

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

  describe '#save' do
    context 'when the IP address is a loopback address' do
      before do
        allow(subject).to receive(:loopback?).and_return(true)
      end

      it 'does not call the IpLocation service' do
        expect(IpLocation).not_to receive(:new)

        subject.save
      end
    end

    context 'when the IP address is not a loopback address' do
      before do
        allow(subject).to receive(:loopback?).and_return(false)
      end

      context 'when geolocation is set' do
        subject { build(:ip_info, latitude: 50, longitude: 4) }

        it 'does not update the record' do
          expect(subject).not_to receive(:update)

          subject.save
        end

        it 'does not change the latitude' do
          expect {
            subject.save
          }.not_to change {
            subject.latitude
          }
        end

        it 'does not change the longitude' do
          expect {
            subject.save
          }.not_to change {
            subject.longitude
          }
        end

        it 'does not set the VPN status' do
          expect {
            subject.save
          }.not_to change {
            subject.is_vpn
          }
        end
      end

      context 'when geolocation is not set' do
        subject { build(:ip_info, latitude: nil, longitude: nil) }

        it 'does updates the record' do
          expect(subject).to receive(:update)

          subject.save
        end

        it 'changes the latitude' do
          expect {
            subject.save
          }.to change {
            subject.latitude
          }.to(lat)
        end

        it 'changes the longitude' do
          expect {
            subject.save
          }.to change {
            subject.longitude
          }.to(lon)
        end

        it 'sets the VPN status' do
          expect {
            subject.save
          }.to change {
            subject.is_vpn
          }.to(false)
        end
      end
    end
  end
end
