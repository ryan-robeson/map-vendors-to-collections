# MapVendorsToCollections

Connects to a given Shopify site and creates smart collections for each vendor.
This has the effect of making the vendor names appear on Shopify's POS for
easier product retrieval based on the vendor.

These collections only need to be created once for each vendor.
They automatically include any product that has their vendor
field set to the corresponding vendor of the collection.

## Installation

1. Clone this repo: `git clone https://github.com/ryan-robeson/map-vendors-to-collections.git`
2. Install:
    * `gem build map_vendors_to_collections.gemspec`
    * `gem install map_vendors_to_collections-$VERSION.gem`

## Usage

This gem can be used as a library, or more easily, with the included `map_vendors_to_collections` binary.
Effort was taken to respect the API's rate limit, however, no effort was taken to ensure that this library is threadsafe.
It is currently seen as a one-off script, rather than being used for multiple sites at the same time.

To run as a library:

```ruby
require "map_vendors_to_collections"
# Setup api key
# api_key = "...."
# Setup api password
# api_pass = "...."
# Setup site name
# site = "...."
mapper = MapVendorsToCollections::Logic.new(api_key, api_pass, site)

# Pass an IO object as the last option if you want debug logs.
# mapper = MapVendorsToCollections::Logic.new(api_key, api_pass, site, $stdout)

# Map the collections.
mapper.run
```

Using the included command:

1. Create a config.yaml that specifies your site's information.

    ```yaml
    ---
    # config.yaml
    :key: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    :password: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
    :site: "my-shopify-site-name"
    ```

2. Run the included command: `map_vendors_to_collections`

3. Watch the output as your site is updated.


## Contributing

1. Fork it ( https://github.com/ryan-robeson/map-vendors-to-collections/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
