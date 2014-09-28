class APIHelper
  include RSpec::Matchers

  def initialize(client)
    @client = client
  end

  def ensure_site(attrs)
    site = client.create_site(attrs)
    expect(client.last_response.status).to eql(201)
    site
  end

  private

  def client
    @client
  end
end
