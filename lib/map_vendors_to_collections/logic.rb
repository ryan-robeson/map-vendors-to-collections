module MapVendorsToCollections
  class Logic
    extend Forwardable
    def_delegator :@rate_limiter, :with_limit, :with_limit

    def initialize(api_key, api_password, site, log_io=nil)
      ShopifyAPI::Base.site = "https://#{api_key}:#{api_password}@#{site}.myshopify.com/admin"
      @rate_limiter = RateLimiter.new

      if log_io
        @logger = Logger.new(log_io).tap do |log|
          log.progname = 'MapVendorsToCollections::Logic'
        end

        ActiveResource::Base.logger = Logger.new(log_io)
      else
        @logger = NullLogger.new
      end
    end

    # This is where the magic happens.
    # It determines what vendors do not already have
    # smart collections and automatically creates them.
    def run()
      product_count = 0
      collection_count = 0

      level = with_limit do
        product_count = ShopifyAPI::Product.count
      end

      @logger.debug "Product count == #{product_count}"
      @logger.debug "Bucket Level is #{level}"

      level = with_limit do
        collection_count = ShopifyAPI::SmartCollection.count
      end

      @logger.debug "Smart Collection count == #{collection_count}"
      @logger.debug "Bucket Level is #{level}"

      return if product_count.zero?

      product_pages = (product_count / LIMIT_PER_CALL).ceil
      collection_pages = (collection_count / LIMIT_PER_CALL).ceil

      @logger.debug "There are #{product_pages} product pages"
      @logger.debug "There are #{collection_pages} product pages"

      products = nil
      collections = nil
      vendors = Set.new
      collection_names = Set.new

      # Loop through all of the products and collect the vendors
      1.upto product_pages do |page|
        @logger.debug "Processing product page #{page}/#{product_pages}"

        level = with_limit do
          products = ShopifyAPI::Product.find(:all, params: { limit: LIMIT_PER_CALL, page: page })
        end
        @logger.debug "Retrieved products page #{page}. Bucket Level is #{level}"

        products.each do |product|
          if not product.vendor.empty?
            vendors.add(product.vendor)
            @logger.debug "Adding #{product.vendor} to vendors set"
          end
        end
      end

      # Loop through all of the collections to collect their names
      1.upto collection_pages do |page|
        @logger.debug "Processing collection page #{page}/#{collection_pages}"

        level = with_limit do
          collections = ShopifyAPI::SmartCollection.find(:all, params: { limit: LIMIT_PER_CALL, page: page })
        end
        @logger.debug "Retrieved collections page #{page}. Bucket Level is #{level}"

        collections.each do |collection|
          collection_names.add(collection.title)
          @logger.debug "Adding #{collection.title} to collection_names set"
        end
      end

      # Get the set of vendors that do not yet have a collection.
      new_vendors = vendors.difference(collection_names)
      @logger.debug "There are #{new_vendors.count} new vendors. They are: #{new_vendors.to_a.join(',')}"

      # Create the smart collections
      @logger.debug "Creating smart collections..."
      new_vendors.each do |v|
        create_smart_collection_for_vendor v
      end
    end

    # Create the smart collection on Shopify.
    # Smart collections automatically include new products
    # that match their conditions so this only needs to be
    # done once per vendor.
    def create_smart_collection_for_vendor(name)
      @logger.debug "Creating smart collection for: #{name}"
      smart_collection = ShopifyAPI::SmartCollection.new
      smart_collection.title = name
      smart_collection.rules = [
        {
          "column" => "vendor",
          "relation" => "equals",
          "condition" => name
        }
      ]

      level = with_limit do
        smart_collection.save
      end
      @logger.debug "Created smart collection: #{name}"
      @logger.debug "Bucket Level is #{level}"
    end
  end
end
