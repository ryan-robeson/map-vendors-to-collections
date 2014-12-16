require "shopify_api"
require "thread"
require "fiber"
require "forwardable"
require "set"
require "map_vendors_to_collections/version"
require "map_vendors_to_collections/null_logger"
require "map_vendors_to_collections/bucket"
require "map_vendors_to_collections/rate_limiter"
require "map_vendors_to_collections/logic"

module MapVendorsToCollections
  BUCKET_SIZE = 40
  LEAK_RATE = 0.5
  LIMIT_PER_CALL = 250.0
end
