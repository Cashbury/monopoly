Then /^I should be able to make a new Money program$/ do
  click_link "New Program"
  within("#new_program") do
    select "Money", :from => "Program type"
    click_button "Create Program"
  end
  # Someone (or something) is cleaning the database too early, I guess.
  sleep(1)
  @current_business.reload
  @current_business.programs.should have(1).items
  @current_business.programs.last.program_type.should == ProgramType["Money"]
end

Then /^I should not be able to make a new Money program$/ do
  last_url = current_path
  visit new_business_program_path(@current_business)
  within "#new_program" do
    page.should_not have_select("Program type", :options => ["Money"])
  end
end
