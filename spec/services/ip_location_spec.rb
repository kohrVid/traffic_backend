require 'rails_helper'

RSpec.describe IpLocation do
  subject { IpLocation.new(ip_address: ip_address) }

  let(:ip_address) { create(:ip_info).address }
  let(:ip_info_url) { "https://ipinfo.io/widget/demo/#{ip_address}" }

  let(:get_ip_info_response) do
    File.read("spec/support/api_responses/get_ip_info.json")
  end

  before do
    stub_request(:get, ip_info_url).with(
      headers: {
        "Accept" => "*/*",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "Content-Type" => "application/json",
        "User-Agent" => "Faraday v2.9.0"
      }
    ).to_return(status: 200, body: get_ip_info_response, headers: {})
  end

  context '#coordinates' do
    it 'returns the coordinates associated with the IP address' do
      expect(subject.coordinates).to eq([52.3740, 4.8897])
    end
  end
end

