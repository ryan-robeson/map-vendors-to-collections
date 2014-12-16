require 'bundler/setup'
require "bundler/gem_tasks"

# Start a console with the gem loaded
task :c do
  require 'pry'
  @gem_name = 'map_vendors_to_collections'
  require @gem_name

  # Reload all loaded files with gem_name
  def reload!
    gem_files = $LOADED_FEATURES.select { |f| f =~ /\/#{@gem_name}/ }
    gem_files.each { |f| load f }
  end

  ARGV.clear

  Pry.start
end
