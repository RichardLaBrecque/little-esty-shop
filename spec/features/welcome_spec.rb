# require 'rails_helper'
#
# RSpec.describe 'the welcome page' do
#   it "displays api consumption functionality" do
#     @repo_name = RepoNameFacade.find_repo_name
#     @contributors = ContributorFacade.find_contributor
#     @pulls = PullsFacade.count_pulls
#
#     visit "/"
#
#     expect(page).to have_content(@repo_name.name)
#     expect(page).to have_content(@contributors.first.name)
#     expect(page).to have_content(@contributors.first.commits)
#     expect(page).to have_content(@pulls.number_of_pulls)
#   end
# end
