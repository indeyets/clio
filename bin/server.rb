require 'webrick'
include WEBrick

require 'fileutils'

port = 0xfeed
base_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))

server = HTTPServer.new({
	:Port			=> port,
	:Logger			=> Log.new($stderr, Log::FATAL),
	:AccessLog		=> [[
		File.open(RUBY_PLATFORM =~ /mswin/ ? 'NUL:' : '/dev/null', 'w'),
		AccessLog::COMBINED_LOG_FORMAT
	]],
	:DocumentRoot	=> File.join(base_path, 'result', ARGV.shift),
})

# trap signals to invoke the shutdown procedure cleanly
['INT', 'TERM'].each { |signal|
   trap(signal){ server.shutdown} 
}

puts "Serving your FriendFeed archive on http://localhost:%d/index.html" % port

server.start
