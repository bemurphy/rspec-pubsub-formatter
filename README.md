rspec-pubsub-formatter
======================

Publishes a json serialized hash to a redis pubsub channel (`pubsub_formatter`
by default)  with the following data:

      {
        :total_example_count => 4,
        :run_example_count   => 2,
        :failure_count       => 1,
        :pending_count       => 0,
        :percent_complete    => 50
      }

The formatter inherits from the `RSpec::Core::Formatters::ProgressFormatter` and
maintains its behavior of reporting, in addition to publishing to redis.
