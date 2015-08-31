require 'rails_helper'

RSpec.describe GroupEvent, type: :model do

  it "can be in published or draft status" do
    group_event = FactoryGirl.build(:complete_group_event)
    ["published", "draft"].each do |status|
      group_event.status = status
      expect(group_event).to be_valid
    end
  end

  it "cannot be in a status other than published or draft" do
    group_event = FactoryGirl.build(:complete_group_event)
    group_event.status = "abcd"
    expect(group_event).to be_invalid
  end

  it "cannot be published unless all fields are present" do
    group_event = FactoryGirl.build(:incomplete_group_event)
    group_event.status = 'published'
    expect(group_event).to be_invalid
  end

  it "can be published if all fields are present" do
    group_event = FactoryGirl.build(:complete_group_event)
    group_event.status = 'published'
    expect(group_event).to be_valid
  end

  it "can calcuate duration if start and end date is present" do
    group_event = FactoryGirl.create(:complete_group_event)
    expect(group_event.duration).to be 1
  end

  it "cannot have start_date after end_date" do
    group_event = GroupEvent.new(start_date: Time.current + 1.day, end_date: Time.current)
    expect(group_event).to be_invalid
  end

end
