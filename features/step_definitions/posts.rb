Given /there is at least one post tagged "([\w\s]+)"/ do |tag_name|
  Factory(:post, :tag_list => [Factory(:tag, :name => tag_name)])
end

Given /there is at least one post titled "([\w\s]+)"/ do |title|
  Factory(:post, :title => title)
end

Given /some post exists/ do
  Factory(:post)
end

Given /^the following posts? exists:$/ do |post_table|
  post_table.hashes.each do |hash|
    Factory(:post, hash)
  end
end

Given /^a posts exists with attributes:$/ do |post_table|
  post_table.hashes.each do |hash|
    Post.first(:conditions => hash).should_not be_nil
  end
end