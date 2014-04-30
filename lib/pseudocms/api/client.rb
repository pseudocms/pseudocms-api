module PseudoCMS
  module API
    class Client

      OPTIONS = [
        :email,
        :password,
        :access_token
      ]

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

      private

      OPTIONS.each do |key|
        send(:define_method, key) { instance_variable_get("@#{key}") }
      end
    end
  end
end
