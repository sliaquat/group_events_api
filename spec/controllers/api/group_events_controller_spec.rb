require 'rails_helper'

RSpec.describe Api::GroupEventsController, type: :controller do

  before(:each) { request.headers['Accept'] = "#{Mime::JSON}" } #instead of appending format: json to each request

  describe "GET #index" do

    before(:each) do
      3.times{FactoryGirl.create(:group_event)}
      get :index
    end

    it "renders the json representation for all group events" do
      expect(json_response.count).to eql 3
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      @group_event = FactoryGirl.create(:group_event)
      get :show, id: @group_event.id
    end

    it "renders the json representation for the group event requested" do
      expect(json_response[:name]).to eql @group_event.name
    end

    it { should respond_with 200 }
  end


  describe "POST #create" do

    context "when is successfully created" do

      before(:each) do
      @group_event_attributes = FactoryGirl.attributes_for(:complete_group_event)
        post :create, { group_event: @group_event_attributes }
      end

      it "renders the json representation for the group event just created" do
        expect(json_response[:name]).to eql @group_event_attributes[:name]
      end

      it { should respond_with 201 }

    end

    context "when is not created" do
      before(:each) do
        @invalid_attributes = { start_date: (Time.current + 1.day).to_s, end_date: (Time.current).to_s }
        post :create, { group_event: @invalid_attributes }
      end

      it "renders the json errors on why the group event could not be created" do
        expect(json_response[:errors][:end_date]).to include "must be after start_date"
      end

      it { should respond_with 422 }
    end

  end

  describe "PUT #update" do

    context "when is successfully updated" do

      before(:each) do
        @group_event = FactoryGirl.create :complete_group_event
        put :update, { id: @group_event.id,
                         group_event: { name: "new_name" } }
      end

      it "renders the json representation for the updated group event" do
        expect(json_response[:name]).to eql "new_name"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        @group_event = FactoryGirl.create :complete_group_event
        put :update, { id: @group_event.id,
                         group_event: { status: "abc" } }
      end

      it "renders the json errors on why the group event could not be updated" do
        expect(json_response[:errors][:status]).to include "Invalid type. Status can be either draft or published"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before do
      @group_event = FactoryGirl.create :complete_group_event
      delete :destroy, { id: @group_event.id }
    end

    it { should respond_with 204 }

  end


end
