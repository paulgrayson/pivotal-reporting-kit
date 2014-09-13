require './boot'
PRKit::Config.configure(api_token: ENV['PIVOTAL_API_TOKEN'])

accepted_in_last_week = PRKit::Query.all_projects.label(:flaky).accepted(after: 1.week.ago).include_done.fetch
accepted_in_last_week.data.each do |story|
  puts story['current_state']
  puts story['accepted_at']
end
