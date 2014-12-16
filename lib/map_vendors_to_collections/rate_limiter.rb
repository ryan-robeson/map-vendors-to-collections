module MapVendorsToCollections
  class RateLimiter
    def initialize
      @bucket = Bucket.new
      @run = run
    end

    # Called like: with_limit { puts "hello"; some_api_call; }
    # Designed to wrap each individual api call.
    def with_limit &block
      @run = run unless @run.alive?
      @run.resume block
    end

    # Calculates the amount that has leaked
    # in the given time frame
    def leak_amount last_leak, finish
      duration = finish - last_leak
      
      leak = duration.floor / LEAK_RATE
      leak
    end

    # Returns a closure that with each
    # call takes the finish time as an
    # argument. It uses this to determine
    # when the bucket has leaked.
    def leak bucket
      last_leak = Time.now
      ->(finish) do
        l = leak_amount last_leak, finish
        unless l == 0
          last_leak = Time.now
          bucket.decrement l
        end
      end
    end

    # Returns a fiber that calls the given block
    # and yields the current bucket level with each call.
    # This can be called with a different block each time.
    def run
      Fiber.new do |block|
        leaker = leak @bucket
        block.call
        @bucket.increment
        finish = Time.now
        leaker.call finish

        loop do
          block = Fiber.yield @bucket.level # Return the bucket level for info purposes
          leaker.call Time.now
          if @bucket.level > (BUCKET_SIZE - 5)
            sleep 5
            leaker.call Time.now
          end

          block.call
          @bucket.increment
          finish = Time.now
          leaker.call finish
        end
      end
    end
  end
end
