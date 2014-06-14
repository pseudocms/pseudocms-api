require 'spec_helper'

describe PseudoCMS::API::Client::Tokens do

  describe "create token" do

    context "when not using basic auth" do
      let(:client) { user_client }

      it "raises an AuthMethodError" do
        expect { client.create_token }.to raise_error(PseudoCMS::API::AuthMethodError)
      end
    end

    context "when using basic auth", :vcr do
      let(:client) { basic_auth_client }

      it "creates a new access token with valid credentials" do
        token = client.create_token(
          client_id: test_api_client_id,
          client_secret: test_api_client_secret
        )

        expect(token).to_not be_nil
        expect(token.access_token).to_not be_nil
        expect(token.token_type).to eql('bearer')
      end

      it "fails to create an access token with bad user credentials" do
        client.instance_variable_set("@password", "bad_password_value!")

        token = client.create_token(
          client_id: test_api_client_id,
          client_secret: test_api_client_secret
        )

        expect(token.error).to eql('invalid_resource_owner')
        expect(client.last_response.status).to be(401)
      end

      it "fails to create an access token with bad client credentials" do
        token = client.create_token(
          client_id: test_api_client_id,
          client_secret: 'bad_secret_value'
        )

        expect(token.error).to eql('invalid_client')
        expect(client.last_response.status).to be(401)
      end
    end
  end
end
