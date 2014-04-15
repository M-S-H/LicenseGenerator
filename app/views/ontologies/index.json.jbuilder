json.array!(@ontologies) do |ontology|
  json.extract! ontology, :id, :name, :url
  json.url ontology_url(ontology, format: :json)
end
