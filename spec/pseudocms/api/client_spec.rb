require 'spec_helper'

describe PseudoCMS::API::Client do

  context 'with basic auth credentials' do
    subject { PseudoCMS::API::Client.new(email: 'test@user.com', password: 'pAssword') }

    its(:basic_authenticated?)       { should be true }
    its(:token_authenticated?)       { should_not be true }
    its(:application_authenticated?) { should_not be true }

    it 'supplies basic auth credentials' do
      url = 'http://test@user.com:pAssword@pseudocms-api.herokuapp.com'
      request = stub_request(:get, url)

      subject.send(:get, '/')
      assert_requested request
    end
  end

  context 'with access token' do
    subject { PseudoCMS::API::Client.new(access_token: 'someAccessToken') }

    its(:token_authenticated?)       { should be true }
    its(:basic_authenticated?)       { should_not be true }
    its(:application_authenticated?) { should_not be true }

    it 'sends authorization header' do
      request = stub_request(:get, api_url('/'))
        .with(headers: { authorization: "Bearer someAccessToken" })

      subject.send(:get, '/')
      assert_requested request
    end
  end

  context 'with application credentials' do
    subject { PseudoCMS::API::Client.new(client_id: '123', client_secret: '234454') }

    its(:application_authenticated?) { should be true }
    its(:basic_authenticated?)       { should_not be true }
    its(:token_authenticated?)       { should_not be true }

    it 'sends client id and client secret as parameters' do
      request = stub_request(:get, api_url('/?client_id=123&client_secret=234454'))
      subject.send(:get, '/')
      assert_requested request
    end
  end
end
