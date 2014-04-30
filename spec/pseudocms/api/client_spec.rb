require 'spec_helper'

describe PseudoCMS::API::Client do

  context 'with basic auth credentials' do
    subject { PseudoCMS::API::Client.new(email: 'test@user.com', password: 'pAssword') }
    its(:basic_auth?) { should be_true }
    its(:token_auth?) { should_not be_true }
  end

  context 'with access token' do
    subject { PseudoCMS::API::Client.new(access_token: 'someAccessToken') }
    its(:token_auth?) { should be_true }
    its(:basic_auth?) { should_not be_true }
  end
end
