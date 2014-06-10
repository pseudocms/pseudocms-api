module PseudoCMS
  module API

    module Authentication

      # Indicates whether or not a username and password are available
      #
      # @return [Boolean]
      def basic_authenticated?
        !!(email && password)
      end

      # Indicates whether or not an OAuth access token is available
      #
      # @return [Boolean]
      def token_authenticated?
        !!access_token
      end

      # Indicates whether or not a client id and secret are available
      #
      # @return [Boolean]
      def application_authenticated?
        !!application_authentication
      end

      private

      def application_authentication
        if client_id && client_secret
          {
            client_id: client_id,
            client_secret: client_secret
          }
        end
      end
    end
  end
end
