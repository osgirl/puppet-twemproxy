require 'beaker-rspec'


# mac users follow https://docs.docker.com/installation/mac/

UNSUPPORTED_PLATFORMS = [ 'Windows', 'Solaris', 'AIX' ]

unless ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no'
  # This will install the latest available package on el and deb based
  # systems fail on windows and osx, and install via gem on other *nixes
  foss_opts = { :default_action => 'gem_install' }

  if default.is_pe?; then install_pe; else install_puppet( foss_opts ); end

  hosts.each do |host|
    on hosts, "mkdir -p #{host['distmoduledir']}"
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do

    puppet_module_install(:source => proj_root, :module_name => 'twemproxy')

    hosts.each do |host|

      # during dev we need a key to access private repo's specified in the Puppetfile.
      if File.exists?(File.join(Dir.home, ".ssh", "github_rsa"))
        github_ssh_key = File.read(File.join(Dir.home, ".ssh", "github_rsa"))
        shell("echo 'Copying local GitHub SSH Key to VM for provisioning...' && mkdir -p /root/.ssh && echo '#{github_ssh_key}' > /root/.ssh/id_rsa && chmod 600 /root/.ssh/id_rsa")
      else
        # make this also work on Jenkins
        # raise IOError, "\n\nERROR: GitHub SSH Key not found at ~/.ssh/github_rsa.\nYou can generate this key manually! \n\n"
      end
  
      # fixup github ssh
      shell("mkdir -p /root/.ssh && touch /root/.ssh/known_hosts && ssh-keyscan -H github.com >> /root/.ssh/known_hosts && chmod 600 /root/.ssh/known_hosts")

      # shame puppet does not know about tar on osx
      shell("gem install minitar --no-ri --no-rdoc")

      # move to Puppetfile location and install deps
      shell("cd #{default['puppetpath']}/modules/twemproxy/files && librarian-puppet install --verbose --path #{default['puppetpath']}/modules")

    end

  end
end