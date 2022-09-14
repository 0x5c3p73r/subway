require 'net/http'

module HttpRequest
  extend ActiveSupport::Concern

  def fetch(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req["User-Agent"] = "Subway/0.1.0"
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(req)
    end

    case res
    when Net::HTTPSuccess
      res
    when Net::HTTPRedirection
      location = res["location"]
      fetch(location)
    else
      res.value
    end
  end
end
