begin
  require 'isolate/now'
rescue LoadError
  abort "This project requires Isolate to work, please 'gem install isolate' first."
end

require 'rubygems/package_task'

# continious testing
desc "Invoke watchr in Isolation mode"
task :watchr, [:options] do |t, args|
  cmd = "#{Gem.ruby} -S watchr #{args.options}"
  puts cmd
  exec cmd
end

# gemspec
spec = Gem::Specification.new do |s|
  s.name    = 'net-snarl'
  s.summary = 'Simple implementation of Snarl SNP protocol'
  s.version = '0.0.1'
  s.author  = 'Luis Lavena'
  s.email   = 'luislavena@gmail.com'
  s.description = <<-EOT
Net::Snarl is a trivial implementation of Snarl SNP protocol. It is aimed to
verbatin return Snarl answers for further processing.
  EOT
  s.homepage = 'http://github.com/luislavena/net-snarl'

  s.require_path = 'lib'
  s.files = FileList[
    'lib/**/*.rb', 'spec/**/*.rb', 'Rakefile',
    'Isolate', 'specs.watchr'
  ]
end

# packaging
Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end
