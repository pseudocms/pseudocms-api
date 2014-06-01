require 'spec_helper'

describe PseudoCMS::API::Client::Users do

  describe "#users" do
    context "blessed app" do
      let(:client) { blessed_client }

      it "returns an array of users" do
        VCR.use_cassette('users') do
          users = client.users
          expect(users).to be_kind_of Array
          assert_requested :get, api_url('/users')
        end
      end

      it "includes links to prev and first pages" do
        VCR.use_cassette('users_second_page') do
          users = client.users(page: 2, per_page: 1)
          expect(users).to be_kind_of Array
          assert_requested :get, api_url('/users?page=2&per_page=1')

          expect(client.has_first_page?).to be_true
          expect(client.has_prev_page?).to be_true
        end
      end

      it "includes links to next and last pages" do
        VCR.use_cassette('users_first_page') do
          users = client.users(per_page: 1)
          expect(users).to be_kind_of Array
          assert_requested :get, api_url('/users?per_page=1')

          expect(client.has_next_page?).to be_true
          expect(client.has_last_page?).to be_true
        end
      end
    end
  end

  describe "single user" do
    context "blessed app" do
      let(:client) { blessed_client }

      it 'cannot get the "current" user' do
        VCR.use_cassette('user_unauthorized') do
          user = client.user
          expect(user).to be_nil
          expect(client.last_response.status).to eql(403)
          assert_requested :get, api_url('/user')
        end
      end

      it 'can get any user by id' do
        VCR.use_cassette('user_first') do
          user = client.user(1)
          expect(user).to_not be_nil
          assert_requested :get, api_url('/users/1')
        end
      end
    end
  end

  describe "create user" do
    context "blessed app" do
      let(:client) { blessed_client }

      it 'creates a user' do
        VCR.use_cassette('user_created') do
          user = client.create_user(email: 'test@vcr.com', password: 'somePAssword1')
          expect(user).to_not be_nil
          expect(client.last_response.status).to eql(201)
          assert_requested :post, api_url('/users')
        end
      end
    end
  end

  describe "update user" do
    context "blessed app" do
      let(:client) { blessed_client }

      it 'updates email and password' do
        VCR.use_cassette('user_updated') do
          user = client.update_user(4, email: 'test@vcr2.com', password: 'newPAssword1')
          # 204s do not have a message body
          # http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
          expect(user).to be_nil
          expect(client.last_response.status).to eql(204)
          assert_requested :patch, api_url('/users/4')
        end
      end
    end
  end

  describe "delete user" do
    context "blessed app" do
      let(:client) { blessed_client }

      it "deletes the specified user" do
        VCR.use_cassette('user_deleted') do
          user = client.delete_user(3)
          expect(user).to be_nil
          expect(client.last_response.status).to eql(204)
          assert_requested :delete, api_url('/users/3')
        end
      end
    end
  end
end
