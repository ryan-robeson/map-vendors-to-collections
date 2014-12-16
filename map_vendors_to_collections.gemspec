# coding: utf-8
require_relative 'lib/map_vendors_to_collections/version'

Gem::Specification.new do |spec|
  spec.name          = "map_vendors_to_collections"
  spec.version       = MapVendorsToCollections::VERSION
  spec.authors       = ["Ryan Robeson"]
  spec.email         = ["ryan.robeson@gmail.com"]
  spec.summary       = %q{Map vendors to smart collections in Shopify.}
  spec.description   = %q{Map vendors' products to smart collections named after the vendor for easier lookups on the POS app. Smart collections automatically include new products that match their conditions so this only has to be run when new vendors are added. This gem provides a library option and a command line program that will accomplish the task. The command line program requires a config.yaml in the current directory that contains the api key, password, and site name to function.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "shopify_api"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
