module HttpRequest
  extend ActiveSupport::Concern

  def fetch(url)
    uri = URI(url)
    conn = Faraday.new(uri.normalize) do |f|
      # default timeout is 60s
      f.adapter :net_http
      f.request :retry, retry_options
      f.response :logger if Rails.env.development?
      f.response :follow_redirects

      f.headers[:user_agent] = "Subway/#{Subway::VERSION}"
    end

    conn.get(uri.path)
  end

  def head(url)
    uri = URI(url)
    conn = Faraday.new(uri.normalize) do |f|
      # default timeout is 60s
      f.adapter :net_http
      f.request :retry, retry_options
      f.response :logger if Rails.env.development?
      f.response :follow_redirects

      f.headers[:user_agent] = "Subway/#{Subway::VERSION}"
    end

    conn.head(uri.path)
  end

  private

  def retry_options
    @retry_options ||= {
      max: 3,
      interval: 0.05,
      interval_randomness: 0.5,
      backoff_factor: 2,
      exceptions: [
        Errno::ECONNREFUSED,
        EOFError,
        Timeout::Error,
        Net::HTTPExceptions
      ]
    }
  end
end
