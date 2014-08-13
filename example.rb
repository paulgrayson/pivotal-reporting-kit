require './boot'

project_ids = QueryAccount.new.project_ids.join(', ')
puts "--------------"
puts project_ids

project_id = 687551

total = QueryProject.new(project_id).label(:flaky).count
unstarted = QueryProject.new(project_id).label(:flaky).status(:unstarted).count
accepted = QueryProject.new(project_id).label(:flaky).status(:accepted).count
in_progress = total - accepted - unstarted

puts "FLAKY REPORT"
puts "--------------"
puts "Total:\t\t#{total}"
printf("Done:\t\t%d (%.1f%%)\n", accepted, accepted.to_f / total * 100)
printf("In Progress:\t%d (%.1f%%)\n", in_progress, in_progress.to_f / total * 100)
printf("To do:\t\t%d (%.1f%%)\n", unstarted, unstarted.to_f / total * 100)


