# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :room1, class: Room do
    host_id 12
    name "Test Room"
    max_user 8
    occupancy 0
    status "open"
  end
end
