require 'spec_helper'

describe "game_histories/show" do
  before(:each) do
    @game_history = assign(:game_history, stub_model(GameHistory,
      :room_id => 1,
      :turn_no => 2,
      :attacker_id => 3,
      :target_id => 4,
      :coordinate_x => 5,
      :coordinate_y => 6,
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/Status/)
  end
end
