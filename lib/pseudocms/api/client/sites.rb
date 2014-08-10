module PseudoCMS
  module API
    class Client

      # Methods for the sites api
      module Sites

        # List all sites
        #
        # @param options [Hash] Optional options
        # @option options [Integer] :page (1) page number
        # @option options [Integer] :per_page (30) sites per page
        # @return [Sawyer::Resource]
        #
        # @example List sites
        #   @client = PseudoCMS::API::Client.new(access_token: 'myToken')
        #   @client.sites
        def sites(options = {})
          get("/sites", options)
        end

        # Get a site
        #
        # @params id [Integer] A site id
        # @params options [Hash] Optional options
        # @return [Sawyer::Resource]
        #
        # @example Get a site
        #   @client = PseudoCMS::API::Client.new(access_token: 'some_token')
        #   @client.site(1)
        def site(id, options = {})
          get("/sites/#{id}", options)
        end

        # Create a new site
        #
        # @params options [Hash] options
        # @option options [String] :name A name for the site
        # @option options [String] :description (nil) A description of the site
        #
        # @example Create a new site
        #   @client = PseudoCMS::API::Client.new(access_token: 'some_token')
        #   @client.create_site(name: "My Site", description: "Optional description")
        def create_site(options = {})
          post("/sites", options)
        end
      end
    end
  end
end
