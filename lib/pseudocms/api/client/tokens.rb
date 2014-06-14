module PseudoCMS
  module API
    class Client

      # Method for the Tokens API
      module Tokens

        # Create OAuth tokens
        #
        # This can only be done using basic auth.
        #
        # @param options [Hash] Options for creating the tokens
        # @option options [String] client_id The client id for the application
        # @option options [String] client_secret The client secret for the application
        #
        # @return [Sawyer::Resource] An access token record
        #
        # @example Create a token (login)
        #   client = PseudoCMS::API::Client.new(email: 'your@email.com', password: 'pAssword1')
        #   client.create_token(client_id: '123', client_secret: '12334')
        def create_token(options = {})
          raise AuthMethodError.new("Only basic auth is supported.") unless basic_authenticated?

          post('/oauth/token', options.merge({
            grant_type: 'password',
            username: email,
            password: password
          }))
        end
      end
    end
  end
end
