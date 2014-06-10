require 'spec_helper'

describe PseudoCMS::API::Client do

  context 'with basic auth credentials' do
    subject { PseudoCMS::API::Client.new(email: 'test@user.com', password: 'pAssword') }

    its(:basic_authenticated?)       { should be_true }
    its(:token_authenticated?)       { should_not be_true }
    its(:application_authenticated?) { should_not be_true }
  end

  context 'with access token' do
    subject { PseudoCMS::API::Client.new(access_token: 'someAccessToken') }

    its(:token_authenticated?)       { should be_true }
    its(:basic_authenticated?)       { should_not be_true }
    its(:application_authenticated?) { should_not be_true }
  end

  context 'with application credentials' do
    subject { PseudoCMS::API::Client.new(client_id: '123', client_secret: '234454') }

    its(:application_authenticated?) { should be_true }
    its(:basic_authenticated?)       { should_not be_true }
    its(:token_authenticated?)       { should_not be_true }
  end
end
