require 'rspec/core/formatters/progress_formatter'
require 'redis'
require 'json'

module RSpecPubsub
  class Formatter < RSpec::Core::Formatters::ProgressFormatter
    attr_reader :channel

    def initialize(output)
      super
      @channel = Channel.new
    end

    def start(example_count)
      super
      publish_status
    end

    def example_passed(example)
      super
      publish_status
    end

    def example_pending(example)
      super
      publish_status
    end

    def example_failed(example)
      super
      publish_status
    end

    private

    def status
      {
        :total_example_count => example_count,
        :run_example_count   => run_example_count,
        :failure_count       => failure_count,
        :pending_count       => pending_count,
        :percent_complete    => percent_complete
      }
    end

    def run_example_count
      examples.length
    end

    def failure_count
      failed_examples.length
    end

    def pending_count
      pending_examples.length
    end

    def percent_complete
      begin
        ((run_example_count / example_count.to_f ) * 100).to_i
      rescue FloatDomainError
        0
      end
    end

    def publish_status
      channel.publish(status)
    end
  end

  class Channel
    attr_reader :redis

    class << self
      attr_writer :name
      def name
        @name || "pubsub_formatter"
      end
    end

    def initialize
      @redis = Redis.new
    end

    def publish(status)
      redis.publish(self.class.name, status.to_json)
    end
  end
end
