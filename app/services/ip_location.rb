require 'faraday'

class IpLocation
  def initialize(ip_address:)
    @ip_address = ip_address
  end

  def coordinates
    JSON.parse(ip_info_response.body)["data"]["loc"].split(/,\s*/).map(&:to_f)
  end

  private

  def url
    "https://ipinfo.io/widget/demo/#{@ip_address}" 
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
end
