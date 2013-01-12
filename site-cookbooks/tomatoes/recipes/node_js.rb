case node['platform_family']
  when 'rhel','fedora'
    package "openssl-devel"
  when 'debian'
    package "libssl-dev"
end

nodejs_tar = "node-v#{node['nodejs']['version']}.tar.gz"
nodejs_tar_path = nodejs_tar
if node['nodejs']['version'].split('.')[1].to_i >= 5
  nodejs_tar_path = "v#{node['nodejs']['version']}/#{nodejs_tar_path}"
end
# Let the user override the source url in the attributes
nodejs_src_url = "#{node['nodejs']['src_url']}/#{nodejs_tar_path}"

remote_file "/usr/local/src/#{nodejs_tar}" do
  source nodejs_src_url
  checksum node['nodejs']['checksum']
  mode 0644
  action :create_if_missing
end

# --no-same-owner required overcome "Cannot change ownership" bug
# on NFS-mounted filesystem
execute "tar --no-same-owner -zxf #{nodejs_tar}" do
  cwd "/usr/local/src"
  creates "/usr/local/src/node-v#{node['nodejs']['version']}"
end

bash "compile node.js" do
  cwd "/usr/local/src/node-v#{node['nodejs']['version']}"
  code <<-EOH
    PATH="/usr/local/bin:$PATH"
    ./configure --prefix=#{node['nodejs']['dir']} && \
    make
  EOH
  creates "/usr/local/src/node-v#{node['nodejs']['version']}/node"
end

execute "nodejs make install" do
  environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "make install"
  cwd "/usr/local/src/node-v#{node['nodejs']['version']}"
  not_if {File.exists?("#{node['nodejs']['dir']}/bin/node") && `#{node['nodejs']['dir']}/bin/node --version`.chomp == "v#{node['nodejs']['version']}" }
end