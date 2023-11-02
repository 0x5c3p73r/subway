# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `faraday-follow_redirects` gem.
# Please instead update this file by running `bin/tapioca gem faraday-follow_redirects`.

# source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#3
module Faraday
  class << self
    # source://faraday/2.6.0/lib/faraday.rb#55
    def default_adapter; end

    # source://faraday/2.6.0/lib/faraday.rb#102
    def default_adapter=(adapter); end

    # source://faraday/2.6.0/lib/faraday.rb#59
    def default_adapter_options; end

    # source://faraday/2.6.0/lib/faraday.rb#59
    def default_adapter_options=(_arg0); end

    # source://faraday/2.6.0/lib/faraday.rb#120
    def default_connection; end

    # source://faraday/2.6.0/lib/faraday.rb#62
    def default_connection=(_arg0); end

    # source://faraday/2.6.0/lib/faraday.rb#127
    def default_connection_options; end

    # source://faraday/2.6.0/lib/faraday.rb#134
    def default_connection_options=(options); end

    # source://faraday/2.6.0/lib/faraday.rb#67
    def ignore_env_proxy; end

    # source://faraday/2.6.0/lib/faraday.rb#67
    def ignore_env_proxy=(_arg0); end

    # source://faraday/2.6.0/lib/faraday.rb#46
    def lib_path; end

    # source://faraday/2.6.0/lib/faraday.rb#46
    def lib_path=(_arg0); end

    # source://faraday/2.6.0/lib/faraday.rb#96
    def new(url = T.unsafe(nil), options = T.unsafe(nil), &block); end

    # source://faraday/2.6.0/lib/faraday.rb#107
    def respond_to_missing?(symbol, include_private = T.unsafe(nil)); end

    # source://faraday/2.6.0/lib/faraday.rb#42
    def root_path; end

    # source://faraday/2.6.0/lib/faraday.rb#42
    def root_path=(_arg0); end

    private

    # source://faraday/2.6.0/lib/faraday.rb#143
    def method_missing(name, *args, &block); end
  end
end

# Main Faraday::FollowRedirects module.
#
# source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#4
module Faraday::FollowRedirects; end

# Public: Follow HTTP 301, 302, 303, 307, and 308 redirects.
#
# For HTTP 301, 302, and 303, the original GET, POST, PUT, DELETE, or PATCH
# request gets converted into a GET. With `:standards_compliant => true`,
# however, the HTTP method after 301/302 remains unchanged. This allows you
# to opt into HTTP/1.1 compliance and act unlike the major web browsers.
#
# This middleware currently only works with synchronous requests; i.e. it
# doesn't support parallelism.
#
# If you wish to persist cookies across redirects, you could use
# the faraday-cookie_jar gem:
#
#   Faraday.new(:url => url) do |faraday|
#     faraday.use FaradayMiddleware::FollowRedirects
#     faraday.use :cookie_jar
#     faraday.adapter Faraday.default_adapter
#   end
#
# source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#23
class Faraday::FollowRedirects::Middleware < ::Faraday::Middleware
  # Public: Initialize the middleware.
  #
  # options - An options Hash (default: {}):
  #     :limit                      - A Numeric redirect limit (default: 3)
  #     :standards_compliant        - A Boolean indicating whether to respect
  #                                  the HTTP spec when following 301/302
  #                                  (default: false)
  #     :callback                   - A callable used on redirects
  #                                  with the old and new envs
  #     :cookies                    - An Array of Strings (e.g.
  #                                  ['cookie1', 'cookie2']) to choose
  #                                  cookies to be kept, or :all to keep
  #                                  all cookies (default: []).
  #     :clear_authorization_header - A Boolean indicating whether the request
  #                                  Authorization header should be cleared on
  #                                  redirects (default: true)
  #
  # @return [Middleware] a new instance of Middleware
  #
  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#56
  def initialize(app, options = T.unsafe(nil)); end

  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#64
  def call(env); end

  private

  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#123
  def callback; end

  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#138
  def clear_authorization_header(env, from_url, to_url); end

  # @return [Boolean]
  #
  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#70
  def convert_to_get?(response); end

  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#115
  def follow_limit; end

  # @return [Boolean]
  #
  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#110
  def follow_redirect?(env, response); end

  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#75
  def perform_with_redirection(env, follows); end

  # @return [Boolean]
  #
  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#145
  def redirect_to_same_host?(from_url, to_url); end

  # Internal: escapes unsafe characters from an URL which might be a path
  # component only or a fully qualified URI so that it can be joined onto an
  # URI:HTTP using the `+` operator. Doesn't escape "%" characters so to not
  # risk double-escaping.
  #
  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#131
  def safe_escape(uri); end

  # @return [Boolean]
  #
  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#119
  def standards_compliant?; end

  # source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#91
  def update_env(env, request_body, response); end
end

# HTTP methods for which 30x redirects can be followed
#
# source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#25
Faraday::FollowRedirects::Middleware::ALLOWED_METHODS = T.let(T.unsafe(nil), Set)

# source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#38
Faraday::FollowRedirects::Middleware::AUTH_HEADER = T.let(T.unsafe(nil), String)

# Keys in env hash which will get cleared between requests
#
# source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#29
Faraday::FollowRedirects::Middleware::ENV_TO_CLEAR = T.let(T.unsafe(nil), Set)

# Default value for max redirects followed
#
# source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#32
Faraday::FollowRedirects::Middleware::FOLLOW_LIMIT = T.let(T.unsafe(nil), Integer)

# HTTP redirect status codes that this middleware implements
#
# source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#27
Faraday::FollowRedirects::Middleware::REDIRECT_CODES = T.let(T.unsafe(nil), Set)

# Regex that matches characters that need to be escaped in URLs, sans
# the "%" character which we assume already represents an escaped sequence.
#
# source://faraday-follow_redirects//lib/faraday/follow_redirects/middleware.rb#36
Faraday::FollowRedirects::Middleware::URI_UNSAFE = T.let(T.unsafe(nil), Regexp)

# Exception thrown when the maximum amount of requests is
# exceeded.
#
# source://faraday-follow_redirects//lib/faraday/follow_redirects/redirect_limit_reached.rb#9
class Faraday::FollowRedirects::RedirectLimitReached < ::Faraday::ClientError
  # @return [RedirectLimitReached] a new instance of RedirectLimitReached
  #
  # source://faraday-follow_redirects//lib/faraday/follow_redirects/redirect_limit_reached.rb#12
  def initialize(response); end

  # Returns the value of attribute response.
  #
  # source://faraday-follow_redirects//lib/faraday/follow_redirects/redirect_limit_reached.rb#10
  def response; end
end

# source://faraday-follow_redirects//lib/faraday/follow_redirects/version.rb#5
Faraday::FollowRedirects::VERSION = T.let(T.unsafe(nil), String)
