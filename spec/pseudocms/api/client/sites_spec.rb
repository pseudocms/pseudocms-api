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

  describe "create site" do

    context "when called by a user" do
      let(:client) { user_client }

      it "creates a new site when given valid options" do
        site = client.create_site(name: "test site", description: "some test description")
        expect(site).to_not be_nil
        expect(client.last_response.status).to eql(201)
        assert_requested :post, api_url("/sites")
      end

      it "won't create a site with invalid options" do
        site = client.create_site(description: "Not going to happen")
        expect(site.errors).to_not be_nil
        expect(client.last_response.status).to eql(422)
      end

      it "won't allow duplicate site names" do
        site = client.create_site(name: "My Test Site")
        expect(client.last_response.status).to eql(201)

        dup_site = client.create_site(name: "My Test Site")
        expect(dup_site.errors).to_not be_nil
        expect(client.last_response.status).to eql(422)
      end

      it "ignores the owner_id parameter if supplied" do
        site = client.create_site(name: "Other user site?", owner_id: -1)
        expect(site).to_not be_nil
        expect(site.user_id).to_not eql(-1)
        expect(client.last_response.status).to eql(201)
      end
    end

    context "when called by a blessed app" do
      let(:client) { blessed_client }

      it "creates a site for the specified owner" do
        site = client.create_site(name: "Your Site", owner_id: 2)
        expect(site).to_not be_nil
        expect(client.last_response.status).to eql(201)
      end

      it "requires a valid owner_id to create a site" do
        site = client.create_site(name: "Some Other Site")
        expect(client.last_response.status).to eql(404)
      end
    end
  end
end
