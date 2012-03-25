Given /I am logged in/ do
  page.visit('/admin/session')
  page.fill_in('login', :with =>'Admin')
  page.fill_in('password', :with => 'testpass$blog')
  page.click_button('Login')
end

Then /a RuntimeError is thrown when I press "(.*)"/ do |button|
  lambda {
    click_button(button)
  }.should raise_error
end

=begin
Then /^the comment exists$/ do
  Comment.count.should == 2
end
=end

Given /^the following comments? exists:$/ do |comment_table|
  comment_table.hashes.each do |hash|
    Factory(:comment, hash)
  end
end

Given /^a comment exists with attributes:$/ do |comment_table|
  comment_table.hashes.each do |hash|
    Comment.find(:first, :conditions => hash).should_not be_nil
  end
end

Given /^a comment does not exist with attributes:$/ do |comment_table|
  comment_table.hashes.each do |hash|
    Comment.find(:first, :conditions => hash).should be_nil
  end
end
