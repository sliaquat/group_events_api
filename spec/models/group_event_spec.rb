require 'rails_helper'

RSpec.describe GroupEvent, type: :model do

  let(:group_event) { FactoryGirl.create(:group_event) }

  context "validations" do
    let(:complete_group_event) { FactoryGirl.build(:complete_group_event) }
    let(:incomplete_group_event) { FactoryGirl.build(:incomplete_group_event) }
    let(:group_event_with_start_date_after_end_date) { FactoryGirl.build(:group_event_with_start_date_after_end_date) }
    let(:group_event_with_same_start_and_end_date) { FactoryGirl.build(:group_event_with_same_start_and_end_date) }
    let(:complete_published_group_event) { FactoryGirl.build(:complete_published_group_event) }
    let(:incomplete_published_group_event) { FactoryGirl.build(:incomplete_published_group_event) }

    it { expect(group_event).to_not allow_value("abc").for(:status) }

    it { expect(group_event).to allow_values("published", "draft").for(:status) }

    it { expect(group_event).to allow_value("<p>Some Text </p>").for(:description) }

    it { expect(group_event).to_not allow_values(-1, "abc").for(:duration) }

    it { expect(group_event).to allow_values(0, 1).for(:duration) }

    it { expect(incomplete_published_group_event).to be_invalid }

    it { expect(complete_published_group_event).to be_valid }

    it { expect(group_event_with_start_date_after_end_date).to be_invalid }

    it { expect(group_event_with_same_start_and_end_date).to be_valid }

  end

  context "Date and duration calculations" do
    it "can calcuate duration if start and end date is present" do
      group_event = GroupEvent.create(start_date: Time.current, end_date: Time.current + 1.day)
      expect(group_event.duration).to be 1
    end

    it "can calcuate end date if start date and duration is present" do
      group_event = GroupEvent.create(start_date: Time.current, duration: 1)
      expect(group_event.end_date.day).to be (group_event.start_date + 1.day).day
    end

    it "can calcuate start date if end date and duration is present" do
      group_event = GroupEvent.create(end_date: Time.current, duration: 1)
      expect(group_event.start_date.day).to be (group_event.end_date - 1.day).day
    end


    #Assumption is made here that start and end dates take precedence over duration
    it "calcuates duration if start and end date is present even if duration is already present" do
      group_event = GroupEvent.create(start_date: Time.current, end_date: Time.current + 1.day, duration: 5)
      expect(group_event.duration).to be 1
    end

  end

  context "Persistance" do
    it "does not remove event from db on destroy" do
      group_event.destroy()
      expect(GroupEvent.unscoped.exists?(group_event.id)).to be true
    end
  end

end
