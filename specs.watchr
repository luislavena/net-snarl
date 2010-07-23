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
  system command
  no_interruption
end

def rspec(*paths)
  run "rspec #{gem_opt} -I#{include_dirs} #{paths.flatten.join(' ')}"
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