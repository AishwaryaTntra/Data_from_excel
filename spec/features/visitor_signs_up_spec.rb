require 'rails_helper'

feature 'Visitor signs up' do
  
  scenario 'with invalid email' do
    sign_up_with 'invalid_email', 'Testuser1', '1234567890', 'password', 'password'

    expect(page).to have_content('Sign up')
  end

  scenario 'with blank password' do
    sign_up_with 'valid@example.com', 'Testuser1', '1234567890', '', ''

    expect(page).to have_content('Sign up')
  end

  def sign_up_with(email, name, phone, password, password_confirmation)
    visit new_user_registration_path
    fill_in 'Email', with: email
    fill_in 'Name', with: name
    fill_in 'Phone', with: phone
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
    click_button 'Sign up'
  end
end
