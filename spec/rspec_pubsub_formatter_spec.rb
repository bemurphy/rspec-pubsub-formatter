require 'rspec-pubsub-formatter'

describe RSpecPubsub::Formatter do
  before do
    @output = StringIO.new
    @channel = stub("Channel", :publish => true)
    RSpecPubsub::Channel.stub(:new).and_return(@channel)
    @formatter = RSpecPubsub::Formatter.new(@output)
  end

  it "publishes its status with example count on start" do
    @channel.should_receive(:publish).with(hash_including(:total_example_count => 5))
    @formatter.start(5)
  end

  it "publishes the count of failed examples" do
    @channel.should_receive(:publish).with(hash_including(:failure_count => 1)).ordered
    @channel.should_receive(:publish).with(hash_including(:failure_count => 2)).ordered
    2.times { @formatter.example_failed(stub) }
  end

  it "publishes the count of pending examples" do
    @channel.should_receive(:publish).with(hash_including(:pending_count => 1)).ordered
    @channel.should_receive(:publish).with(hash_including(:pending_count => 2)).ordered
    2.times { @formatter.example_pending(stub) }
  end

  it "publishes the count of examples run so far" do
    @channel.should_receive(:publish).with(hash_including(:run_example_count => 1)).ordered
    @channel.should_receive(:publish).with(hash_including(:run_example_count => 2)).ordered
    2.times do
      example = stub
      @formatter.example_started(example)
      @formatter.example_failed(example)
    end
  end

  it "publishes the percentage of examples completed" do
    @formatter.start(2)
    @channel.should_receive(:publish).with(hash_including(:percent_complete => 50)).ordered
    @channel.should_receive(:publish).with(hash_including(:percent_complete => 100)).ordered
    2.times do
      example = stub
      @formatter.example_started(example)
      @formatter.example_passed(example)
    end
  end
end
