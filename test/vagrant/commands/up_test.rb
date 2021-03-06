require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class CommandsUpTest < Test::Unit::TestCase
  setup do
    @klass = Vagrant::Commands::Up

    @env = mock_environment
    @instance = @klass.new(@env)
  end

  context "executing" do
    should "call all or single for the method" do
      @instance.expects(:all_or_single).with([], :up)
      @instance.execute
    end
  end

  context "upping a single VM" do
    setup do
      @vm = mock("vm")
      @vm.stubs(:env).returns(@env)

      @vms = {:foo => @vm}
      @env.stubs(:vms).returns(@vms)
    end

    should "error and exit if the VM doesn't exist" do
      @env.stubs(:vms).returns({})
      @instance.expects(:error_and_exit).with(:unknown_vm, :vm => :foo).once
      @instance.up_single(:foo)
    end

    should "start created VMs" do
      @vm.stubs(:created?).returns(true)
      @vm.expects(:start).once
      @instance.up_single(:foo)
    end

    should "up non-created VMs" do
      @vm.stubs(:created?).returns(false)
      @vm.env.expects(:require_box).once
      @vm.expects(:up).once
      @vm.expects(:start).never
      @instance.up_single(:foo)
    end
  end
end
