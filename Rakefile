begin
  require 'isolate/now'
rescue LoadError => e
  abort "This project requires Isolate to work, please 'gem install isolate' first."
end

desc "Invoke watchr in Isolation mode"
task :watchr, [:options] do |t, args|
  cmd = "#{Gem.ruby} -S watchr #{args.options}"
  puts cmd
  exec cmd
end
