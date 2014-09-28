RSpec.shared_examples "a paginated resource" do
  it "returns an array" do
    results = client.public_send(pagination_method)
    expect(results).to be_kind_of Array
    assert_requested :get, api_url("/#{pagination_method}")
  end

  it "includes links to prev and first pages" do
    results = client.public_send(pagination_method, page: 2, per_page: 1)
    assert_requested :get, api_url("/#{pagination_method}?page=2&per_page=1")

    expect(client.has_first_page?).to be true
    expect(client.has_prev_page?).to be true
  end

  it "includes links to next and last pages" do
    results = client.public_send(pagination_method, per_page: 1)
    expect(results).to be_kind_of Array
    assert_requested :get, api_url("/#{pagination_method}?per_page=1")

    expect(client.has_next_page?).to be true
    expect(client.has_last_page?).to be true
  end
end
