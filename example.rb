require './boot'

puts all.label(:flaky).event(:created).since(1.week.ago).run.json


