 $:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'net/snarl'

# Run me with:
#   $ watchr specs.watchr

# --------------------------------------------------
# Rules
# --------------------------------------------------
watch('^spec/(.*)_spec\.rb')    { |m| run_spec_matching(m[1]) }
watch('^lib/(.*)\.rb')          { |m| run_spec_matching(m[1]) }
watch('^spec/spec_helper\.rb')  { run_all_specs }
watch('^spec/support/.*\.rb')   { run_all_specs }

# --------------------------------------------------
# RSpec specifics
# --------------------------------------------------
def all_spec_files
  Dir.glob('spec/**/*_spec.rb')
end

def run_all_specs
  rspec all_spec_files
end

def run_spec_matching(thing_to_match)
  matches = all_spec_files.grep(/#{thing_to_match}/i)
  if matches.empty?
    puts "Sorry, thanks for playing, but there were no matches for #{thing_to_match}"
  else
    rspec matches
  end
end

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
def no_interruption
  @interrupted = false
end

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    exit
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    run_all_specs
  end
end

# --------------------------------------------------
# Helpers
# --------------------------------------------------
def run(command)
  system clearscreen
  puts command
  output = `#{command}`
  no_interruption
  puts output
  output
end

def rspec(*paths)
  output = run("rspec #{gem_opt} -I#{include_dirs} #{paths.flatten.join(' ')}")
  notify output
end

def include_dirs
  %w(. lib spec).join(File::PATH_SEPARATOR)
end

def gem_opt
  defined?(Gem) ? "-rubygems" : ""
end

def clearscreen
  RbConfig::CONFIG['host_os'] =~ /mingw|mswin/ ? 'cls' : 'clear'
end

def notify(output)
  title = File.basename(File.dirname(__FILE__))
  output =~ /(\d+)\sexample.?,\s(\d+)\sfailure.?(,\s(\d+)\spending)?/
  examples, failures, pending = $1.to_i, $2.to_i, $4.to_i
  defaults = {
    :app => 'autotest',
    :timeout => 5
  }
  if failures > 0
    snarl.notify(defaults.merge(
      :title => title,
      :text => "#{examples} examples, #{failures} failures",
      :icon => File.expand_path('~/.snarl/fail.png')
    ))
  elsif pending > 0
    snarl.notify(defaults.merge(
      :title => title,
      :text => "#{pending} pending",
      :icon => File.expand_path('~/.snarl/pending.png')
    ))
  else
    snarl.notify(defaults.merge(
      :title => title,
      :text => "No failures or pending",
      :icon => File.expand_path('~/.snarl/pass.png')
    ))
  end
end

def snarl
  @snarl ||= Net::Snarl.new
  @snarl.register('autotest')
  @snarl
end
