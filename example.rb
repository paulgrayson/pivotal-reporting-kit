require './boot'

project_id = 687551

total = PivotalQuery.project(project_id).label(:flaky).count
unstarted = PivotalQuery.project(project_id).label(:flaky).status(:unstarted).count
accepted = PivotalQuery.project(project_id).label(:flaky).status(:accepted).count
in_progress = total - accepted - unstarted

puts "FLAKY REPORT"
puts "--------------"
puts "Total:\t\t#{total}"
printf("Done:\t\t%d (%.1f%%)\n", accepted, accepted.to_f / total * 100)
printf("In Progress:\t%d (%.1f%%)\n", in_progress, in_progress.to_f / total * 100)
printf("To do:\t\t%d (%.1f%%)\n", unstarted, unstarted.to_f / total * 100)


