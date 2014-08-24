require './boot'

all_flaky = Query.all_projects.label(:flaky).include_done.fetch
total = all_flaky.count

unstarted = all_flaky.data.select {|story| story['current_state'] == 'unstarted'}.count
# TODO unstarted = all_flaky.status(:unstarted).count

accepted = all_flaky.data.select {|story| story['current_state'] == 'accepted'}.count
# TODO accepted = all_flaky.status(:accepted).count

# As separated queries..
#unstarted = Query.all_projects.label(:flaky).status(:unstarted).fetch.item_count
#accepted = Query.all_projects.label(:flaky).include_done.status(:accepted).fetch.item_count

in_progress = total - accepted - unstarted

puts "FLAKY REPORT"
puts "--------------"
puts "Total:\t\t#{total}"
printf("Done:\t\t%d (%.1f%%)\n", accepted, accepted.to_f / total * 100)
printf("In Progress:\t%d (%.1f%%)\n", in_progress, in_progress.to_f / total * 100)
printf("To do:\t\t%d (%.1f%%)\n", unstarted, unstarted.to_f / total * 100)


