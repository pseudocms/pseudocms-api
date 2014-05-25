module PseudoCMS
  module API
    class Client

      # Methods for the users api
      module Users

        # List all users
        #
        # @param options [Hash] Optional options
        # @option options [Integer] :page (1) page number
        # @option options [Integer] :per_page (30) users per page
        # @return [Sawyer::Resource]
        #
        # @example List users
        #   @client = PseudoCMS::API::Client.new(access_token: 'myToken')
        #   @client.users
        def users(options = {})
          get('/users', options)
        end

        # Get a specific user
        #
        # @param user_id [Integer] A user id
        # @param options [Hash] Optional options
        # @return [Sawyer::Resource]
        #
        # @example Get the current user
        #   @client = PseudoCMS::API::Client.new(access_token: 'some_token')
        #   @client.user
        #
        # @example Get a specific user
        #   @client = PseudoCMS::API::Client.new(access_token: 'some_token')
        #   @client.user(1)
        def user(user_id = nil, options = {})
          if user_id
            get("/users/#{user_id}", options)
          else
            get('/user', options)
          end
        end

        # Create a new user
        #
        # @param options [Hash] A customizable set of options
        # @option options [String] :email
        # @option options [String] :password
        # @return [Sawyer::Resource]
        #
        # @example Create a new user
        #   @client = PseudoCMS::API::Client.new(access_token: 'some_token')
        #   @client.create_user(email: 'you@domain.com', password: 'SomePassword')
        def create_user(options)
          post('/users', options)
        end

        # Update an existing user
        #
        # @param id [Integer] The id of the user to update
        # @param options [Hash] Properties to update
        # @option options [String] :email (nil)
        # @option options [String] :password (nil)
        # @return [Sawyer::Resource]
        #
        # @example Update a user's email address
        #   @client = PseudoCMS::API::Client.new(access_token: 'token')
        #   @client.update_user(1, email: 'new@email.com')
        def update_user(id, options)
          patch("/users/#{id}", options)
        end
      end
    end
  end
end
