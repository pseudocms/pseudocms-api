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
      end
    end
  end
end
