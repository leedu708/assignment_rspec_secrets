require 'rails_helper'

feature 'Visitor Functionality' do

  before do
    create(:secret)
    visit root_path
  end

  scenario 'visitor can view all secrets' do
    expect(page).to have_content "Listing secrets"
  end

  scenario 'able to get to sign-up page' do
    click_link "All Users"
    click_link "New User"
    expect(page).to have_content "Password"
  end

  scenario 'author names for secrets are hidden from visitors' do
    expect(page).to have_content "**hidden**"
  end

  scenario 'visitor should be redirect to login when trying to show a user' do
    visit user_path(User.first)
    expect(current_path).to eq(new_session_path)
  end

end

feature 'Sign up flow' do

  before do
    visit root_path
    click_link "All Users"
    click_link "New User"
  end

  scenario 'visitor can sign up with valid information' do

    name = "footest"
    email = "#{name}@example.com"
    fill_in "Name", with: name
    fill_in "Email", with: email
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_button "Create User"

    expect(current_path).to eq(user_path(User.last))

    expect(page).to have_content name

    expect(page).to have_content email

  end

end

feature 'Sign in and sign out' do

  let(:user) { create(:user) }

  before do
    visit root_path
  end

  scenario 'visitor can sign in with valid information' do
    click_link "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content "Welcome, #{user.name}"
  end

  scenario 'sign in with invalid information should bring login page' do
    click_link "Login"
    fill_in "Email", with: 'invalid_email@test.com'
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content "Login"

  end

  scenario 'signing out returns to root_path' do
    click_link "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "Logout"
    expect(page).to have_content "Login"
  end

end

feature 'making secrets with signed in user' do

  let(:user) { create(:user) }

  before do
    visit new_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end

  scenario 'user can create a secret' do
    click_link 'New Secret'
    title = 'Test title'
    body = 'Test sentence'

    fill_in "secret_title", with: title
    fill_in "secret_body", with: body
    click_button "Create Secret"

    expect(page).to have_content "successfully created"
    expect(page).to have_content title
    expect(page).to have_content body
  end

  scenario 'user can edit a secret' do
    secret = create(:secret, :author_id => user.id)
    visit secrets_path

    expect(page).to have_link('Edit', :href => "/secrets/#{secret.id}/edit")

    edit_title = "New title"

    find_link('Edit', :href => "/secrets/#{secret.id}/edit").click
    fill_in "secret_title", with: edit_title
    click_button "Update Secret"

    expect(page).to have_content(edit_title)
  end

  scenario 'user can delete a secret' do
    secret = create(:secret, :author_id => user.id)
    visit secrets_path

    expect(page).to have_link('Destroy', :href => "/secrets/#{secret.id}")

    find_link('Destroy', :href => "/secrets/#{secret.id}").click

    expect(page).not_to have_content(secret.title)
  end

end