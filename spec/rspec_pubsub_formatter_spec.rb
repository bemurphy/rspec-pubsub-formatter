require 'rspec-pubsub-formatter'

describe RSpecPubsub::Formatter do
  let(:output) { StringIO.new }
  let(:channel) { stub("Channel", :publish => true) }
  subject{ RSpecPubsub::Formatter.new(output) }

  before do
    RSpecPubsub::Channel.stub(:new).and_return(channel)
  end

  it "publishes its status with example count on start" do
    channel.should_receive(:publish).with(hash_including(:total_example_count => 5))
    subject.start(5)
  end

  it "publishes the count of failed examples" do
    channel.should_receive(:publish).with(hash_including(:failure_count => 1))
    channel.should_receive(:publish).with(hash_including(:failure_count => 2))
    2.times { subject.example_failed(stub) }
  end

  it "publishes the count of pending examples" do
    channel.should_receive(:publish).with(hash_including(:pending_count => 1))
    channel.should_receive(:publish).with(hash_including(:pending_count => 2))
    2.times { subject.example_pending(stub) }
  end

  it "publishes the count of examples run so far" do
    channel.should_receive(:publish).with(hash_including(:run_example_count => 1))
    channel.should_receive(:publish).with(hash_including(:run_example_count => 2))
    2.times do
      example = stub
      subject.example_started(example)
      subject.example_failed(example)
    end
  end

  it "publishes the percentage of examples completed" do
    subject.start(2)
    channel.should_receive(:publish).with(hash_including(:percent_complete => 50))
    channel.should_receive(:publish).with(hash_including(:percent_complete => 100))
    2.times do
      example = stub
      subject.example_started(example)
      subject.example_passed(example)
    end
  end
end
