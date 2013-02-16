require 'spec_helper'

describe "game_histories/new" do
  before(:each) do
    assign(:game_history, stub_model(GameHistory,
      :room_id => 1,
      :turn_no => 1,
      :attacker_id => 1,
      :target_id => 1,
      :coordinate_x => 1,
      :coordinate_y => 1,
      :status => "MyString"
    ).as_new_record)
  end

  it "renders new game_history form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => game_histories_path, :method => "post" do
      assert_select "input#game_history_room_id", :name => "game_history[room_id]"
      assert_select "input#game_history_turn_no", :name => "game_history[turn_no]"
      assert_select "input#game_history_attacker_id", :name => "game_history[attacker_id]"
      assert_select "input#game_history_target_id", :name => "game_history[target_id]"
      assert_select "input#game_history_coordinate_x", :name => "game_history[coordinate_x]"
      assert_select "input#game_history_coordinate_y", :name => "game_history[coordinate_y]"
      assert_select "input#game_history_status", :name => "game_history[status]"
    end
  end
end
