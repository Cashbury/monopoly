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
  @current_business.programs.last.program_type.should == ProgramType.where(:name => 'Money').first
end
