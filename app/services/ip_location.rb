require 'faraday'

class IpLocation
  def initialize(ip_address:)
    @ip_address = ip_address
    @ip_info_response = ip_info_response
  end

  def coordinates
    ip_info_data['loc'].split(/,\s*/).map(&:to_f)
  end

  def vpn?
    ip_info_data['privacy']['vpn']
  end

  private

  def ip_info_data
    JSON.parse(@ip_info_response.body)['data']
  end

  def ip_info_response
    uri = URI(url)

    conn = Faraday.new(
      url: url,
      headers: { "Content-Type" => "application/json" },
      request: { timeout: 1 }
    )

    conn.get(uri.request_uri)
  end

  def url
    "https://ipinfo.io/widget/demo/#{@ip_address}"
  end
end
