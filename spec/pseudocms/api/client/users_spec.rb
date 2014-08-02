require 'spec_helper'

describe PseudoCMS::API::Client::Users, :vcr do

  describe "users" do
    context "when called by a user" do
      let(:client) { user_client }

      it "returns unauthorized" do
        users = client.users
        expect(users).to be_nil
        expect(client.last_response.status).to be(403)
        assert_requested :get, api_url('/users')
      end
    end

    context "when called by a blessed app" do
      let(:client)            { blessed_client }
      let(:pagination_method) { :users }

      it_behaves_like "a paginated resource"
    end
  end

  describe "user" do

    context "when called by a user" do
      let(:client) { user_client }

      it "can get the current user" do
        user = client.user
        expect(user).to_not be_nil
        expect(client.last_response.status).to be(200)
        assert_requested :get, api_url('/user')
      end

      it "can get themselves" do
        user = client.user(2)
        expect(user).to_not be_nil
        expect(client.last_response.status).to be(200)
        assert_requested :get, api_url('/users/2')
      end

      it "cannot get other users" do
        user = client.user(1)
        expect(user).to be_nil
        expect(client.last_response.status).to be(403)
        assert_requested :get, api_url('/users/1')
      end
    end

    context "when called by a blessed app" do
      let(:client) { blessed_client }

      it 'cannot get the "current" user' do
        user = client.user
        expect(user).to be_nil
        expect(client.last_response.status).to eql(403)
        assert_requested :get, api_url('/user')
      end

      it 'can get any user by id' do
        user = client.user(1)
        expect(user).to_not be_nil
        assert_requested :get, api_url('/users/1')
      end
    end
  end

  describe "create user" do
    context "when called be a user" do
      let(:client) { user_client }

      it "returns unauthorized" do
        user = client.create_user(email: 'some@email.com', password: 'somePAssword1')
        expect(user).to be_nil
        expect(client.last_response.status).to be(403)
        assert_requested :post, api_url('/users')
      end
    end

    context "when called by a blessed app" do
      let(:client) { blessed_client }

      it 'creates a user' do
        user = client.create_user(email: 'test@vcruser.com', password: 'somePAssword1')
        expect(user).to_not be_nil
        expect(client.last_response.status).to eql(201)
        assert_requested :post, api_url('/users')
      end
    end
  end

  describe "update user" do
    context "when called be a user" do
      let(:client) { user_client }

      it "can update their own account" do
        user = client.update_user(2, email: 'mutotest@pseudocms.com')
        expect(client.last_response.status).to be (204)
        assert_requested :patch, api_url('/users/2')
      end

      it "cannot update other user's account info" do
        user = client.update_user(4, email: 'some@email.com')
        expect(user).to be_nil
        expect(client.last_response.status).to be(403)
        assert_requested :patch, api_url('/users/4')
      end
    end

    context "when called by a blessed app" do
      let(:client) { blessed_client }

      it 'updates email and password' do
        user = client.update_user(4, email: 'test@vcr2.com', password: 'newPAssword1')
        # 204s do not have a message body
        # http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
        expect(user).to be_nil
        expect(client.last_response.status).to eql(204)
        assert_requested :patch, api_url('/users/4')
      end
    end
  end

  describe "delete user" do
    context "when called by a user" do
      let(:client) { user_client }

      it "returns unauthorized" do
        user = client.delete_user(3)
        expect(user).to be_nil
        expect(client.last_response.status).to eql(403)
        assert_requested :delete, api_url('/users/3')
      end
    end

    context "when called by a blessed app" do
      let(:client) { blessed_client }

      it "deletes the specified user" do
        user = client.delete_user(4)
        expect(user).to be_nil
        expect(client.last_response.status).to eql(204)
        assert_requested :delete, api_url('/users/4')
      end
    end
  end
end
