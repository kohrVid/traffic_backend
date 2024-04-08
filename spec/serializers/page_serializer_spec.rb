# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageSerializer do
  context '#serializable_hash' do
    subject { PageSerializer.new(page).serializable_hash }
    let(:page) { create(:page) }

    it 'returns the page ID' do
      expect(subject[:id]).to eq(page.id)
    end

    it 'returns the page name' do
      expect(subject[:name]).to eq(page.name)
    end

    it 'returns the page URL' do
      expect(subject[:url]).to eq(page.url)
    end
  end
end
