# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.

require 'webmock/rspec'
require 'vcr'
require 'pry'
require 'rspec/its'

Dir["./spec/support/**/*.rb"].each { |file| require file }
require File.expand_path('../../lib/pseudocms/api', __FILE__)

WebMock.disable_net_connect!

VCR_FILTERS = [
  :API_EMAIL,
  :API_EMAIL_ENCODED,
  :API_PASSWORD,
  :API_ACCESS_TOKEN,
  :API_CLIENT_ID,
  :API_CLIENT_SECRET,
  :API_CLIENT_TOKEN
]

def load_env(filename = '.env')
  return unless File.exists?(filename)

  File.foreach(filename) do |line|
    next if line.chomp.size == 0

    setting = line.split('=')
    key = setting.shift
    ENV[key] = setting.join('').chomp
  end
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  load_env
end

VCR.configure do |vcr|
  vcr.configure_rspec_metadata!
  vcr.default_cassette_options = {
    serialize_with: :json,
    preserve_exact_body_bytes: true,
    decode_compressed_response: true,
    record: ENV['TRAVIS'] ? :none : :once
  }

  VCR_FILTERS.each do |key|
    vcr.define_cassette_placeholder("<#{key}>") do
      send("test_#{key.downcase}")
    end
  end

  vcr.cassette_library_dir = 'spec/cassettes'
  vcr.hook_into :webmock
end

def user_client
  PseudoCMS::API::Client.new(access_token: test_api_access_token)
end

def blessed_client
  PseudoCMS::API::Client.new(access_token: test_api_client_token)
end

def basic_auth_client
  PseudoCMS::API::Client.new(email: test_api_email, password: test_api_password)
end

def test_api_email
  ENV.fetch('PSEUDOCMS_TEST_API_EMAIL', 'test@user.com')
end

def test_api_email_encoded
  test_api_email.sub(/@/, '%40')
end

def test_api_password
  ENV.fetch('PSEUDOCMS_TEST_API_PASSWORD', 'super_secure_password')
end

def test_api_access_token
  ENV.fetch('PSEUDOCMS_TEST_API_ACCESS_TOKEN', 'x' * 40)
end

def test_api_client_id
  ENV.fetch('PSEUDOCMS_TEST_API_CLIENT_ID', 'x' * 40)
end

def test_api_client_secret
  ENV.fetch('PSEUDOCMS_TEST_API_CLIENT_SECRET', 'x' * 40)
end

def test_api_client_token
  ENV.fetch('PSEUDOCMS_TEST_API_CLIENT_TOKEN', 'x' * 40)
end

def api_url(url)
  url =~ /^http/ ? url : "#{PseudoCMS::API::API_ENDPOINT}#{url}"
end
