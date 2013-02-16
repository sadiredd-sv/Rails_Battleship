require 'spec_helper'

describe "game_histories/index" do
  before(:each) do
    assign(:game_histories, [
      stub_model(GameHistory,
        :room_id => 1,
        :turn_no => 2,
        :attacker_id => 3,
        :target_id => 4,
        :coordinate_x => 5,
        :coordinate_y => 6,
        :status => "Status"
      ),
      stub_model(GameHistory,
        :room_id => 1,
        :turn_no => 2,
        :attacker_id => 3,
        :target_id => 4,
        :coordinate_x => 5,
        :coordinate_y => 6,
        :status => "Status"
      )
    ])
  end

  it "renders a list of game_histories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
