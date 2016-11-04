json.array!(@comments) do |comment|
  json.extract! comment, :article_id, :name, :content
  json.url comment_url(comment, format: :json)
end
