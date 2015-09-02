require 'rails_helper'

RSpec.describe Api::GroupEventsController, type: :controller do

  describe "GET #index" do

    before(:each) do
      3.times{FactoryGirl.create(:group_event)}
      get :index, format: :json
    end

    it "renders the json representation for all group events" do
      # event_response = JSON.parse(response.body, symbolize_names: true)
      event_response = json_response
      expect(event_response[:group_events].count).to be 3
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      @group_event = FactoryGirl.create(:group_event)
      get :show, id: @group_event.id, format: :json
    end

    it "renders the json representation for the group event requested" do
      event_response = JSON.parse(response.body, symbolize_names: true)
      expect(event_response[:name]).to eql @group_event.name
    end

    it { should respond_with 200 }
  end


  describe "POST #create" do

    context "when is successfully created" do

      before(:each) do
      @group_event_attributes = FactoryGirl.attributes_for(:complete_group_event)
        post :create, { group_event: @group_event_attributes }, format: :json
      end

      it "renders the json representation for the group event just created" do
        event_response = JSON.parse(response.body, symbolize_names: true)
        expect(event_response[:name]).to eql @group_event_attributes[:name]
      end

      it { should respond_with 201 }

    end

  end

  context "when is not created" do
    before(:each) do
      @invalid_attributes = { start_date: (Time.current + 1.day).to_s, end_date: (Time.current).to_s }
      post :create, { group_event: @invalid_attributes }, format: :json
    end

    it "renders the json errors on why the group event could not be created" do
      event_response = JSON.parse(response.body, symbolize_names: true)
      expect(event_response[:errors][:end_date]).to include "must be after start_date"
    end

    it { should respond_with 422 }
  end

  describe "PUT #update" do

    context "when is successfully updated" do

      before(:each) do
        @group_event = FactoryGirl.create :complete_group_event
        put :update, { id: @group_event.id,
                         group_event: { name: "new_name" } }, format: :json
      end

      it "renders the json representation for the updated group event" do
        event_response = JSON.parse(response.body, symbolize_names: true)
        expect(event_response[:name]).to eql "new_name"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        @group_event = FactoryGirl.create :complete_group_event
        put :update, { id: @group_event.id,
                         group_event: { status: "abc" } }, format: :json
      end

      it "renders the json errors on why the group event could not be updated" do
        event_response = JSON.parse(response.body, symbolize_names: true)
        expect(event_response[:errors][:status]).to include "Invalid type"
      end

      it { should respond_with 422 }
    end
  end


  describe "DELETE #destroy" do
    before do
      @group_event = FactoryGirl.create :complete_group_event
      delete :destroy, { id: @group_event.id }, format: :json
    end

    it { should respond_with 204 }

  end


end
