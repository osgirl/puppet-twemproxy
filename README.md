Puppet-twemproxy
================

This module manages [twemproxy](http://www.github.com/twitter/twemproxy) package installation from source. It is based on and compatible with [puppet-twemproxy](https://forge.puppetlabs.com/wuakitv/twemproxy).

The support version of twemproxy is 0.4.1 to take advantage of various improvements and in addtion working tests and addtional stats parameters have been added.

> Currently acceptance test using centos 6.5

> Currently only supports **REDIS** and not memcached.

## USAGE

```ruby
        twemproxy::resource::nutcracker { 'redis-twemproxy':
          port                 => '6379',
          nutcracker_hash      => 'fnv1a_64',
          nutcracker_hash_tag  => '{apple}',
          distribution         => 'ketama',
          auto_eject_hosts     => true,

          verbosity            => 11,

          log_dir              => '/var/log/nutcracker',
          pid_dir              => '/var/run/nutcracker',
          redis                => true,

          statsaddress         => '127.0.0.1',
          statsport            => 22222,
          statsinterval        => 10000,
          mbuf                 => 16384, # default 16384 bytes recommend 512 bytes

          members              =>  [
           {
              'ip'         => 'myhost6390.domain',
              'name'       => 'redis-6390',
              'redis_port' => '6390',
              'weight'     => '1'
            },
            {
              'ip'         => 'myhost6391.domain',
              'name'       => 'redis-6391',
              'redis_port' => '6391',
              'weight'     => '1'
            },
            {
              'ip'         => 'myhost6391.domain',
              'name'       => 'redis-6392',
              'redis_port' => '6392',
              'weight'     => '1'
            }
          ]
        }    
```

## Testing

```bash
bundle install
bundle exec rake test
bundle exec rake beaker

BEAKER_setfile=spec/acceptance/nodesets/centos-7-x64.yml bundle exec rake beaker
```

## Dependencies

1. puppetlabs/stdlib


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
