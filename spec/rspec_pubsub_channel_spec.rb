require 'rspec-pubsub-formatter'

describe RSpecPubsub::Channel do
  let(:redis) { stub("Redis") }
  let(:status) { { :foo => "bar", :fizz => "buzz" } }

  before do
    Redis.stub(:new).and_return(redis)
  end

  it "publishes the provided hash to redis as json" do
    redis.should_receive(:publish).with("pubsub_formatter", status.to_json)
    subject.publish(status)
  end

  it "allows changing the channel name via the class" do
    RSpecPubsub::Channel.channel_name = "blam"
    redis.should_receive(:publish).with("blam", status.to_json)
    subject.publish(status)
  end
end
