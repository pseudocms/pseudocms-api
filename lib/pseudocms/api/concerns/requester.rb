module PseudoCMS
  module API
    module Requester

      private

      [:get, :post, :patch, :delete].each do |method|
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
        [' ', ''].include?(last_response.data) ? nil : last_response.data
      end
    end
  end
end
