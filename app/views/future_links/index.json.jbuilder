json.array!(@future_links) do |future_link|
  json.extract! future_link, :id, :name, :link, :description
  json.url future_link_url(future_link, format: :json)
end
