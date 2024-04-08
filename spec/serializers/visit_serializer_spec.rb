# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VisitSerializer do
  context '#serializable_hash' do
    subject { VisitSerializer.new(visit).serializable_hash }
    let(:visit) { create(:visit, :with_ip_info, user: create(:user)) }

    it 'returns the visit ID' do
      expect(subject[:id]).to eq(visit.id)
    end

    it 'returns the ID of the associated page' do
      expect(subject[:page_id]).to eq(visit.page.id)
    end

    it 'returns the name of the associated page' do
      expect(subject[:page_name]).to eq(visit.page.name)
    end

    it 'returns the URL of the associated page' do
      expect(subject[:page_url]).to eq(visit.page.url)
    end

    it 'returns the ID of the associated user' do
      expect(subject[:user_id]).to eq(visit.user.id)
    end

    it 'returns the visited_at time' do
      expect(subject[:visited_at]).to eq(visit.visited_at)
    end

    it 'returns the address of the associated IpInfo record' do
      expect(subject[:ip_address]).to eq(visit.ip_info.address)
    end

    it 'returns the latitude of the associated IpInfo record' do
      expect(subject[:latitude]).to eq(visit.ip_info.latitude)
    end

    it 'returns the longitude of the associated IpInfo record' do
      expect(subject[:longitude]).to eq(visit.ip_info.longitude)
    end
  end
end
