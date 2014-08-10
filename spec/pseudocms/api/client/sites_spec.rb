require "spec_helper"

describe PseudoCMS::API::Client::Sites, :vcr do

  describe "sites" do
    let(:pagination_method) { :sites }

    context "when called by a user" do
      let(:client) { user_client }

      it_behaves_like "a paginated resource"

      it "includes only sites for this user" do
        sites = client.sites
        expect(sites.uniq { |site| site.user_id }.size).to eql(1)
      end
    end

    context "when called by a blessed app" do
      let(:client) { blessed_client }

      it_behaves_like "a paginated resource"

      it "includes sites from all users" do
        sites = client.sites
        expect(sites.uniq { |site| site.user_id }.size).to be > 1
      end
    end
  end

  describe "site" do

    it "returns nil when a site is not found" do
      client = blessed_client
      site = client.site(0)
      expect(site).to be_nil
      expect(client.last_response.status).to be(404)
    end

    context "when called by a user" do
      let(:client) { user_client }

      it "can get a site owned by this user" do
        site = client.site(1)
        expect(site).to_not be_nil
        assert_requested :get, api_url("/sites/1")
      end

      it "can get a site that is associated with this user" do
        site = client.site(5)
        expect(site).to_not be_nil
      end

      it "cannot get a site that is neither owned by nor associated with this user" do
        site = client.site(4)
        expect(site).to be_nil
        expect(client.last_response.status).to be(403)
      end
    end

    context "when called by a blessed app" do
      let(:client) { blessed_client }

      it "can get any site" do
        site = client.site(1)
        expect(site).to_not be_nil
      end
    end
  end
end
