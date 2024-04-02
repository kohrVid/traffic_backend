require 'rails_helper'

RSpec.describe IpInfo, type: :model do
  subject { create(:ip_info) }

  describe '#address' do
    context 'when it is missing or blank' do
      let(:new_ip) do
        IpInfo.new(address: '')
      end

      before { new_ip.save }

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
      let(:new_ip) do
        IpInfo.new(address: subject.address)
      end

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
