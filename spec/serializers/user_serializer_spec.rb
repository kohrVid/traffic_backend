# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer do
  context '#serializable_hash' do
    subject { UserSerializer.new(user).serializable_hash }
    let(:user) { create(:user) }

    it 'returns the user ID' do
      expect(subject[:id]).to eq(user.id)
    end

    it "returns the user's username" do
      expect(subject[:username]).to eq(user.username)
    end

    it "returns the user's email" do
      expect(subject[:email]).to eq(user.email)
    end

    it "returns the user's admin status" do
      expect(subject[:is_admin]).to eq(user.is_admin)
    end

    it 'returns the address of the associated IpInfo record' do
      expect(
        subject[:registration_ip_info][:address]
      ).to eq(user.registration_ip_info.address)
    end

    it 'returns the latitude of the associated IpInfo record' do
      expect(
        subject[:registration_ip_info][:latitude]
      ).to eq(user.registration_ip_info.latitude)
    end

    it 'returns the longitude of the associated IpInfo record' do
      expect(
        subject[:registration_ip_info][:longitude]
      ).to eq(user.registration_ip_info.longitude)
    end

    it "returns the user's created_at date" do
      expect(subject[:created_at]).to eq(user.created_at)
    end

    it "returns the user's updated_at date" do
      expect(subject[:updated_at]).to eq(user.updated_at)
    end
  end
end
