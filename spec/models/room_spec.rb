require 'spec_helper'

describe Room do

  context "A room should be able to create by a user" do
    subject(:user) { FactoryGirl.build(:user1) }
    its(:name) {should == 'user1'}
  end
  #
  #context "should be able to respond to theses attributes"  do
  #  subject(:room1) { FactoryGirl.build(:room1) }
  #  it { should respond_to(:max_user) }
  #  it { should respond_to(:status) }
  #  it { should respond_to(:name) }
  #  it { should respond_to(:host_id)}
  #end
  #
  #describe "when name is not present" do
  #  subject(:room1) { FactoryGirl.build(:room1) }
  #  before { room1.name = '' }
  #  it { should_not be_valid }
  #
  #end
  #
  #describe "#deploy_ships" do
  #  let(:ship1) { FactoryGirl.build(:ship_id1_1) }
  #  let(:ship2) { FactoryGirl.build(:ship_id1_2) }
  #  let(:room) { FactoryGirl.build(:room1) }
  #  let(:user) { FactoryGirl.build(:user1) }
  #  it "should save information in database" do
  #
  #  end
  #end
  #
  #describe "when room size is invalid" do
  #  before { user.name = " " }
  #  it { should_not be_valid }
  #end

end
