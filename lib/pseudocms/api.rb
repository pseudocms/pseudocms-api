require "pseudocms/api/version"

module PseudoCMS
  module API

    API_ENDPOINT = "http://pseudocms-api.herokuapp.com".freeze
    ACCEPT       = "application/vnd.pseudocms.v1+json".freeze
    CONTENT_TYPE = "application/json".freeze
    USER_AGENT   = "PseudoCMS API Gem #{PseudoCMS::API::VERSION}".freeze

    CONVENIENCE_OPTIONS = {
      query: [:page, :per_page]
    }.freeze

    class AuthMethodError < StandardError; end
  end
end

require "pseudocms/api/client"

class Sawyer::Serializer
  def decode(data)
    return nil if data.nil? || data.strip.empty?
    decode_object(@load.call(data))
  end
end
