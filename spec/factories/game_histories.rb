# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_history do
    room_id 1
    turn_no 1
    attacker_id 1
    target_id 1
    coordinate_x 1
    coordinate_y 1
    status "MyString"
  end
end
