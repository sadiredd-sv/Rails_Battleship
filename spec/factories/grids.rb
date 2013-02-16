# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ship_id1_1, class: Grid do
    user_id 1
    coordinate_x 0
    coordinate_y 0
    alignment 'v'
    current_coordinate_x 0
    current_coordinate_y 0
    ship_size 2
    ship_id 1
  end

  factory :ship_id1_2, class: Grid do
    user_id 1
    coordinate_x 0
    coordinate_y 1
    alignment 'v'
    current_coordinate_x 0
    current_coordinate_y 0
    ship_size 2
    ship_id 1
  end

end
