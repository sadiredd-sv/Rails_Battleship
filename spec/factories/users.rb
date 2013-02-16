# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user1, class: User do
    name "user1"
    email "user1@gmail.com"
    password "password"
    password_confirmation "password"
    #association :grids, factory: :ship_id1_1
  end

  factory :user2, class: User do
    name "user2"
    email "user2@gmail.com"
    password "password"
    password_confirmation "password"
  end

  factory :user3, class: User do
    name "user3"
    email "user3@gmail.com"
    password "password"
    password_confirmation "password"
  end

  factory :user_example, class: User do
    name "Example User"
    email "user@example.com"
    password "foobar"
    password_confirmation "foobar"
  end


  factory :user_test_signup, class: User do
    name "Test Signup"
    email "testsignup@example.com"
    password "password"
    password_confirmation "password"
  end
end
