require 'spec_helper'

describe Grid do

  context 'should response to attributes' do
    subject(:ship_id1) {FactoryGirl.build(:ship_id1_1)}
    it { should respond_to(:ship_id) }
    it { should respond_to(:ship_size) }
    it { should respond_to(:alignment) }
    it { should respond_to(:coordinate_x) }
    it { should respond_to(:coordinate_y) }
    it { should respond_to(:current_coordinate_x) }
    it { should respond_to(:current_coordinate_y) }
  end

  context 'should contain valid attributes' do
    subject(:ship_id1) {FactoryGirl.build(:ship_id1_1)}
    its(:coordinate_x) { should be_between(0, 9) }
    its(:coordinate_y) { should be_between(0, 9) }
    its(:current_coordinate_x) { should be_between(0, 9) }
    its(:current_coordinate_y) { should be_between(0, 9) }

  end

  context 'should expect error with attribute validation' do
    #subject(:ship_id1) {FactoryGirl.build(:ship_id1_1)}
    let(:ship_id1) { FactoryGirl.build(:ship_id1_1)}
    subject { ship_id1 }
    before do
      ship_id1.coordinate_x = ""
      ship_id1.coordinate_y = ''
    end

  end



end
