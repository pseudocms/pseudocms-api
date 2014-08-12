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

  describe "update site" do
    let(:helper) { APIHelper.new(client) }

    it "returns a 404 when the site cannot be found" do
      client = blessed_client
      client.update_site(0, name: "Valid name")
      expect(client.last_response.status).to eql(404)
    end

    context "when called by a user" do
      let(:client) { user_client }

      it "updates the specified attributes" do
        site = helper.ensure_site(name: "Original name", description: "First description")

        client.update_site(site.id, name: "Updated name", description: "Second desc")
        expect(client.last_response.status).to eql(204)
        assert_requested :patch, api_url("/sites/#{site.id}")
      end

      it "fails with missing attributes" do
        site = helper.ensure_site(name: "Original name", description: "First description")

        client.update_site(site.id, name: "")
        expect(client.last_response.status).to eql(422)
      end

      it "wont allow duplicate names" do
        first_site   = helper.ensure_site(name: "Its My Name")
        second_site  = helper.ensure_site(name: "Or is it?")

        client.update_site(second_site.id, name: "Its My Name")
        expect(client.last_response.status).to eql(422)
      end
    end

    context "when called by a blessed app" do
      let(:client) { blessed_client }

      it "can update a site" do
        site = helper.ensure_site(name: "Blessed Site", owner_id: 2)

        client.update_site(site.id, name: "Updated blessed site")
        expect(client.last_response.status).to eql(204)
      end
    end
  end

  describe "delete" do
    let(:helper) { APIHelper.new(client) }

    it "returns a 404 when the site cannot be found" do
      client = blessed_client
      client.delete_site(0)
      expect(client.last_response.status).to eql(404)
    end

    context "when called by a user" do
      let(:client) { user_client }

      it "can delete a site owned by this user" do
        site = helper.ensure_site(name: "site to be deleted")

        client.delete_site(site.id)
        expect(client.last_response.status).to eql(204)
        assert_requested :delete, api_url("/sites/#{site.id}")
      end
    end

    context "when called by a blessed app" do
      let(:client) { blessed_client }

      it "can delete any site" do
        site = helper.ensure_site(name: "To be deleted by a blessed app", owner_id: 2)

        client.delete_site(site.id)
        expect(client.last_response.status).to eql(204)
      end
    end
  end
end
