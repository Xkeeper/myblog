require 'factory_girl'

Factory.define(:tag, :class => ActsAsTaggableOn::Tag) do |a|
  a.name 'Tag'
end

Factory.define(:post) do |a|
  a.title     'A post'
  a.slug      'a-post'
  a.body      'This is a post'

  a.published_at 1.day.ago
  a.created_at   1.day.ago
  a.updated_at   1.day.ago
end
