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
end
