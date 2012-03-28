Factory.define :post do |post|
  post.sequence(:title) {|n| "My title - #{n}"}
  post.body "My body"
  post.tag_list "My tag"
end