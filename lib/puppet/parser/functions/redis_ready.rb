#
# redis_ready.rb
#
#

module Puppet::Parser::Functions
  newfunction(:redis_ready, :type => :rvalue, :doc => <<-EOS
Returns a true members of a redis cluster are ready for operations.

Prototype:

    redis_ready(m)

Where m is an hash of redis members to test.

For example:

  Given the following statements:

    :members => [
           { 
              'ip'         => '127.0.0.1',
              'name'       => 'server1',
              'redis_port' => '6390',
              'weight'     => '1'
            },
            { 
              'ip'         => '127.0.0.1',
              'name'       => 'server2',
              'redis_port' => '6391',
              'weight'     => '1'
            },
            { 
              'ip'         => '127.0.0.1',
              'name'       => 'server3',
              'redis_port' => '6392',
              'weight'     => '1'
            }
      ]

    redis_ready(members)
    
  The result will be a hash of connected (those that are true) states as follows:

    {"127.0.0.1:6390"=>{"connected"=>true}, "127.0.0.1:6391"=>{"connected"=>true}}

  Known issues:

    EOS
  ) do |*arguments|
    #
    # This is to ensure that whenever we call this function from within
    # the Puppet manifest or alternatively from a template it will always
    # do the right thing ...
    #
    arguments = arguments.shift if arguments.first.is_a?(Array)

    raise Puppet::ParseError, "redis_ready(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)" if arguments.size < 2

    m = arguments.shift
    r = arguments.shift

    raise Puppet::ParseError, 'redis_ready(): Requires an array of members type ' +
      'to work with' unless m.is_a?(Array)

    unless r.class.ancestors.include?(Numeric) or r.is_a?(String)
      raise Puppet::ParseError, 'redis_ready(): Requires a numeric number of retries type ' +
         'to work with'
    end

    require 'socket'
    require 'timeout'

    @capture = Hash.new
    @retries = Integer(r)

    for i in 1..@retries

      m.each do |value|
        begin
          entry = value['ip'] + ":" + value['redis_port']
          Timeout.timeout(100) do
            begin
              TCPSocket.new(value['ip'], value['redis_port'])
              @capture[entry] = { 'connected' => true }
            rescue Exception => exception
              case exception
                when Errno::ECONNRESET,Errno::ECONNABORTED,Errno::ETIMEDOUT,Errno::ECONNREFUSED
                  @capture[entry] = { 'connected' => false }
                else
                  raise exception
              end
            end
          end
        rescue Timeout::Error
          puts "#{entry} timed out..."
        end
      end #m.each do |value| 

      clustered = @capture.select{|key, hash| hash['connected'] == true }
      if clustered.empty?
        puts "No cluster found, attempt #{i} of #{@retries}"
      else
        puts "Cluster found for #{clustered} restarting service"
        #exec('service redis-twemproxy restart')
        break
      end

      sleep 1 

    end #for i in 1..@retries

  end
end

# vim: set ts=2 sw=2 et :
# encoding: utf-8
