require './boot'

def report(params)
  Report.new.report(params)
end

r = report(envelope: true, limit: 3)
puts r.ok?
puts r.json
