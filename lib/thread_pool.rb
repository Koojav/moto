module Moto
  class ThreadPool

    def initialize(size=1)
      @size = size
      @jobs = Queue.new
      @pool = Array.new(@size) do |i|
        Thread.new do
          Thread.current[:id] = i
          catch(:exit) do
            loop do
              job, args = @jobs.pop
              job.call(*args)
            end
          end
        end
      end
    end

    def schedule(*args, &block)
      @jobs << [block, args]
    end

    def shutdown
      @size.times do
        schedule { throw :exit }
      end
      @pool.each(&:join)
    end

  end
end