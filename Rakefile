require 'rubygems'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = Dir.glob('spec/**/spec_*.rb')
  t.spec_opts << '--format specdoc'
  t.rcov = true
end

task :run do
  system "rp5 run necat.rb"
end

task :watch do
  system "rp5 watch necat.rb"
end
