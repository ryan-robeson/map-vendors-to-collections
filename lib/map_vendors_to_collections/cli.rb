require "yaml"
require "thor"
require "map_vendors_to_collections"

module MapVendorsToCollections
  class Cli < Thor
    package_name "MapVendorsToCollections"

    desc "map_vendors", "Map vendor names to collections"
    option :config, default: "config.yaml", desc: "The path to a YAML file containing your site's api key, api password, and site name.", aliases: ["-c"]
    def map_vendors
      config = YAML.load_file(options[:config])
      mapper = MapVendorsToCollections::Logic.new(config[:key], config[:password], config[:site], $stdout)
      begin
        mapper.run
      rescue EOFError
        puts "There was an error during processing. You may need to run the program again to finish creating collections."
      end
    end

    default_task :map_vendors
  end
end
