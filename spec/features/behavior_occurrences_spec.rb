require 'rails_helper'

RSpec.feature "Behavior occurrences", type: :feature do
  include ActiveSupport::Testing::TimeHelpers

  let(:date) { time.to_date }
  let(:time) { Time.zone.parse("2023-07-16T18:11:00Z") }
  around do |example|
    travel_to(time) do
      example.run
    end
  end

  before do
    visit root_path
    click_link "Stress Barking"
  end

  scenario "create a new occurrence" do
    within "tr[data-date='#{date.iso8601}']" do
      fill_in("behavior_occurrence_amount", with: "2")
      click_button "Update"
      expect(find("input#behavior_occurrence_amount").value.to_f).to eq(2.0)
    end
  end

  scenario "update occurrence amount" do
    within "tr[data-date='#{date.iso8601}']" do
      fill_in("behavior_occurrence_amount", with: "4")
      click_button "Update"
      fill_in("behavior_occurrence_amount", with: "2")
      click_button "Update"
      expect(find("input#behavior_occurrence_amount").value.to_f).to eq(2.0)
    end
  end

  scenario "remove an occurrence" do
    within "tr[data-date='#{date.iso8601}']" do
      fill_in("behavior_occurrence_amount", with: "2")
      click_button "Update"
      click_button "-1"
      expect(find("input#behavior_occurrence_amount").value.to_f).to eq(1.0)
    end
  end
end
