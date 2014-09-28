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
        # @param id [Integer] A site id
        # @param options [Hash] Optional options
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
        # @param options [Hash] options
        # @option options [String] :name A name for the site
        # @option options [String] :description (nil) A description of the site
        #
        # @example Create a new site
        #   @client = PseudoCMS::API::Client.new(access_token: 'some_token')
        #   @client.create_site(name: "My Site", description: "Optional description")
        def create_site(options)
          post("/sites", options)
        end

        # Update a site
        #
        # @param id [Integer] The site to update
        # @param options [Hash] Attributes to be updated
        # @option options [String] The name of the site
        # @option options [String] The description
        #
        # @example
        #   client = PseudoCMS::API::Client.new(access_token: 'some_token')
        #   client.update_site(1, name: "New Name", description: "New Description")
        def update_site(id, options)
          patch("/sites/#{id}", options)
        end

        # Delete a site
        #
        # @param id [Integer] The site to delete
        # @param options [Hash] Optional options
        #
        # @example
        #   client = PseudoCMS::API::Client.new(access_token: 'some_token')
        #   client.delete_site(1)
        def delete_site(id, options = {})
          delete("/sites/#{id}", options)
        end
      end
    end
  end
end
