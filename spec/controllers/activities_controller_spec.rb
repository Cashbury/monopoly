require File.dirname(__FILE__) + '/../spec_helper'

describe ActivitiesController do

  it "create action should create a new record and return the object" do
    @request.env["HTTP_ACCEPT"] = "application/xml"
    activity = File.read("#{RAILS_ROOT}/spec/fixtures/activities.xml")
    post :create, :activity => activity
    response.should be_success
    assert_equal "application/xml", response.content_type
  end
end