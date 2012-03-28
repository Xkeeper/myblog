# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

body_string = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit,sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'

1.upto(100) do |i|
  Post.create(:title => "Test blog post",
               :body =>body_string,
               :tag_list => ['test_tag','test_tag2','test_tag3','test_tag4','test_tag5','test_tag6','test_tag7','test_tag8','test_tag9'],
               :published_at => i.month.ago)
end
