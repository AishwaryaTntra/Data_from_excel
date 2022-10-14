require 'rails_helper'

feature 'Visitor updates account' do
  let!(:role) { create :role, :user }
  let!(:user) { create :user, :user1, role_id: role.id }
  scenario 'with invalid password' do
    login_with user.email, user.password

    update_with user.email, user.name, user.phone, '123456', '1234561', 'password123'

    expect(page).to have_content('Current password is invalid')
  end

  scenario 'with blank password' do
    login_with user.email, user.password

    update_with user.email, user.name, user.phone, '', '', user.password

    expect(page).to have_content('Your account has been updated successfully.')
  end

  def login_with(email, password)
    visit new_user_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end
  def update_with(email, name, phone, password, password_confirmation, current_password)
    visit edit_user_registration_path
    fill_in 'Email', with: email
    fill_in 'Name', with: name
    fill_in 'Phone', with: phone
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
    fill_in 'Current password', with: current_password
    click_button 'Update'
  end
end
