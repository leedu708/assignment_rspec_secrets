FactoryGirl.define do

  factory :user, :aliases => [:author] do
    sequence(:name) { |n| "Foo#{n}" }
    email { "#{name}@bar.com" }
    password "password"
    password_confirmation "password"
  end

  factory :secret do
    title "Foo Title"
    body "Foo Secret"
    author
  end

end