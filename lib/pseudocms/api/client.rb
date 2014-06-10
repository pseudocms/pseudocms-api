require "sawyer"
require "pseudocms/api/concerns/authentication"
require "pseudocms/api/concerns/pagination"
require "pseudocms/api/concerns/requester"
require "pseudocms/api/client/users"

module PseudoCMS
  module API
    class Client
      include Authentication
      include Pagination
      include Requester

      include Users

      OPTIONS = [
        :email,
        :password,
        :access_token,
        :client_id,
        :client_secret
      ]

      attr_reader :last_response

      def initialize(options)
        OPTIONS.each do |key|
          instance_variable_set("@#{key}", options[key])
        end
      end

      private

      OPTIONS.each do |key|
        send(:define_method, key) { instance_variable_get("@#{key}") }
      end

      def agent
        @agent ||= Sawyer::Agent.new(API_ENDPOINT, sawyer_options) do |http|
          http.headers[:accept]       = ACCEPT
          http.headers[:user_agent]   = USER_AGENT
          http.headers[:content_type] = CONTENT_TYPE

          case
          when basic_authenticated?
            http.basic_auth(email, password)
          when token_authenticated?
            http.authorization("Bearer", access_token)
          when application_authenticated?
            http.params = http.params.merge(application_authentication)
          end
        end
      end

      def sawyer_options
        {
          faraday: Faraday.new(connection_options),
          links_parser: Sawyer::LinkParsers::Simple.new
        }
      end

      def connection_options
        {
          headers: {
            accept: ACCEPT,
            user_agent: USER_AGENT
          }
        }
      end
    end
  end
end
