require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "tests"
  t.libs << "lib"
  t.test_files = FileList['tests/test*.rb']
  t.verbose = true
  t.warning = true
end
