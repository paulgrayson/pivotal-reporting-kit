require './boot'

project_ids = QueryAccount.new.project_ids
puts "--------------"
puts project_ids.join(', ')

total = 0
unstarted = 0
accepted = 0

project_ids.each do |project_id|
  total += QueryProject.new(project_id).label(:flaky).include_done.count
  unstarted += QueryProject.new(project_id).label(:flaky).status(:unstarted).count
  accepted += QueryProject.new(project_id).label(:flaky).include_done.status(:accepted).count
end
in_progress = total - accepted - unstarted

puts "FLAKY REPORT"
puts "--------------"
puts "Total:\t\t#{total}"
printf("Done:\t\t%d (%.1f%%)\n", accepted, accepted.to_f / total * 100)
printf("In Progress:\t%d (%.1f%%)\n", in_progress, in_progress.to_f / total * 100)
printf("To do:\t\t%d (%.1f%%)\n", unstarted, unstarted.to_f / total * 100)


