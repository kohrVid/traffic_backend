require 'rails_helper'

RSpec.describe User, type: :model do
  let(:ip_location) { double(:ip_location) }

  before do
    allow(IpLocation).to receive(:new)
      .and_return(ip_location)

    allow(ip_location).to receive(:coordinates)
      .and_return([])

    allow(ip_location).to receive(:vpn?).and_return(false)
  end

  describe 'validations' do
    describe ':username' do
      context 'when it is missing or blank' do
        let(:new_user) do
          build(:user, username: '')
        end

        before { new_user.save }

        it 'is invalid' do
          expect(new_user).not_to be_valid
        end

        it 'raises the correct error message' do
          expect(
            new_user.errors.messages[:username]
          ).to include("can't be blank")
        end
      end

      context 'when a record with the same username already exists' do
        let(:ip_info) { create(:ip_info) }
        let(:existing_user) { create(:user, registration_ip_info: ip_info) }

        let(:new_user) do
          build(
            :user,
            registration_ip_info: ip_info,
            username: existing_user.username
          )
        end

        before do
          existing_user
          new_user.save
        end

        it 'is invalid' do
          expect(new_user).not_to be_valid
        end

        it 'raises the correct error message' do
          expect(
            new_user.errors.messages[:username]
          ).to include("has already been taken")
        end
      end
    end
  end

  describe '#save' do
    subject do
      build(:user, registration_ip_info_attributes: { address: ip_address })
    end

    let(:ip_info) { create(:ip_info) }
    let(:ip_address) { ip_info.address }

    before do
      ip_info
      subject.save
    end

    it 'associates the User with a registration IP' do
      expect(subject.registration_ip_info).to be_a(IpInfo)
    end

    context 'when the IP address already exists in the database' do
      it 'associates the User with an existing IpInfo record' do
        expect(subject.registration_ip_info).to eq(ip_info)
      end
    end

    context 'when the IP address does not exist in the database' do
      let(:ip_address) { '213.152.176.139' }

      it 'associates the User with a new IpInfo record' do
        expect(subject.registration_ip_info).to eq(IpInfo.last)
        expect(subject.registration_ip_info.address).to eq(ip_address)
      end
    end
  end

  describe '#visits' do
    let(:user) do
      create(:user, :random_name)
    end

    it 'can be associated with visits' do
      expect(user).to respond_to(:visits)
    end
  end
end
