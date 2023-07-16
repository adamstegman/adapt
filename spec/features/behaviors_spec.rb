require "rails_helper"

RSpec.feature "Behaviors", type: :feature do
  before do
    visit root_path
  end

  scenario "create a new occurrence" do
    within "#behavior_1" do
      click_button "0"
      expect(find("input[type=submit]").value).to eq("1")
    end
  end

  scenario "add an occurrence" do
    within "#behavior_1" do
      click_button "0"
      click_button "1"
      expect(find("input[type=submit]").value).to eq("2")
    end
  end
end
