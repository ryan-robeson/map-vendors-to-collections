module MapVendorsToCollections
  class Bucket
    def initialize
      @value = 0
      @mutex = Mutex.new
    end

    def level
      @value
    end

    def increment
      @mutex.synchronize do
        @value = @value + 1
      end
    end

    def decrement(i=1)
      @mutex.synchronize do
        if @value - i > 0
          @value = @value - i
        else
          @value = 0
        end
      end
    end
  end
end
