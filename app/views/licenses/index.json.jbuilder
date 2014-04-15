json.array!(@licenses) do |license|
  json.extract! license, :id, :name, :ontology_id
  json.url license_url(license, format: :json)
end
