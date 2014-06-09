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
  end
end

require "pseudocms/api/client"
