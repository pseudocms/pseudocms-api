require "sawyer"
require "pseudocms/api/client/users"

module PseudoCMS
  module API
    class Client

      OPTIONS = [
        :email,
        :password,
        :access_token
      ]

      attr_reader :last_response

      def initialize(options)
        OPTIONS.each do |key|
          instance_variable_set("@#{key}", options[key])
        end
      end

      def basic_auth?
        !!(email && password)
      end

      def token_auth?
        !!access_token
      end

      # has_first_page?, has_prev_page?, has_next_page?, has_last_page?
      [:first, :prev, :next, :last].each do |rel|
        send(:define_method, "has_#{rel.to_s}_page?") do
          last_response && last_response.rels[rel]
        end
      end

      include Users

      private

      OPTIONS.each do |key|
        send(:define_method, key) { instance_variable_get("@#{key}") }
      end

      [:get, :post, :patch].each do |method|
        send(:define_method, method) do |path, options = {}|
          request(method, path, options)
        end
      end

      def request(method, path, data, options = {})
        if data.is_a?(Hash)
          options[:query] = data.delete(:query) || {}
          options[:headers] = data.delete(:headers) || {}

          CONVENIENCE_OPTIONS.each do |key, values|
            values.each do |param|
              options[key][param] = data.delete(param) if data.has_key?(param)
            end
          end
        end

        @last_response = agent.call(method, URI::Parser.new.escape(path), data, options)
        last_response.data == " " ? nil : last_response.data
      end

      def agent
        @agent ||= Sawyer::Agent.new(API_ENDPOINT, sawyer_options) do |http|
          http.headers[:accept]       = ACCEPT
          http.headers[:user_agent]   = USER_AGENT
          http.headers[:content_type] = CONTENT_TYPE

          http.authorization("Bearer", access_token)
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
