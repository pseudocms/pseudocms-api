require 'spec_helper'

describe PseudoCMS::API::Client::Tokens do

  describe "create token", :vcr do

    context "when using basic auth" do
      let(:client) { basic_auth_client }

      it "creates a new access token" do
        token = client.create_token(
          client_id: test_api_client_id,
          client_secret: test_api_client_secret
        )

        expect(token).to_not be_nil
        expect(token.access_token).to_not be_nil
        expect(token.token_type).to eql('bearer')
        #assert_requested :post, api_url('/oauth/token')
      end
    end
  end
end
