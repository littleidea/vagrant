module Vagrant
  class Commands
    # Bring up a vagrant instance. This handles everything from importing
    # the base VM, setting up shared folders, forwarded ports, etc to
    # provisioning the instance with chef. {up} also starts the instance,
    # running it in the background.
    class Up < Base
      Base.subcommand "up", self
      description "Creates the vagrant environment"

      def execute(args=[])
        all_or_single(args, :up)
      end

      def up_single(name)
        vm = env.vms[name.to_sym]
        if vm.nil?
          error_and_exit(:unknown_vm, :vm => name)
          return # for tests
        end

        if vm.created?
          vm.env.logger.info "VM '#{name}' already created. Booting if its not already running..."
          vm.start
        else
          vm.env.require_box

          vm.env.logger.info "Creating VM '#{name}'"
          vm.up
        end
      end

      def options_spec(opts)
        opts.banner = "Usage: vagrant up"
      end
    end
  end
end
