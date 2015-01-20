#!/usr/bin/ruby

require 'logger'
require 'optparse'

$logger = Logger.new($stdout)


#
# options
#

DEFAULT_OPTIONS = {
	# interval for refreshing process list
	interval: 15,
	# processes
	processes: []
}
options = DEFAULT_OPTIONS
opt = OptionParser.new
opt.on('-i INTERVAL', '--interval INTERVAL') do |v|
	interval = v.to_i
	raise ArgumentError, "invalid interval" if interval <= 0
	options[:interval] = interval
end
opt.on('-c COMMAND_NAME', '--command COMMAND_NAME') do |v|
	options[:processes] << v
end
opt.parse!(ARGV)
options.freeze


#
# spawn a process
#

# spawn a process
pid = spawn(ARGV.join(" "))

# Start a watch thread
Thread.start(options, pid) do |options, pid|
	running = true
	loop do
		# get a process list
		ps_result = `ps h -e -o comm`.split("\n").uniq

		# get processes specified in option
		exist_processes = ps_result.select {|comm|
			options[:processes].any? {|opt_pname| comm == opt_pname}
		}

		if not exist_processes.empty? and running
			# one or more processes are running
			$logger.info "Stop. (process:#{exist_processes.join(",")})"
			Process.kill :STOP, pid
			running = false
		elsif exist_processes.empty? and not running
			# any processes are not running
			$logger.info "Continue."
			Process.kill :CONT, pid
			running = true
		end
		sleep options[:interval]
	end
end

# wait for exit
Process.wait(pid)

