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
