bash "make vcap local copy from local http repo" do
  user "root" 
  cwd "/srv" 
  code <<-EOH
  apt-get install unzip
  wget http://10.1.1.241/master
  unzip master
  mv ./cloudfoundry-vcap-* ./vcap
  EOH
 not_if {"ls /srv/vcap/dev_setup" }

end


git node['cloudfoundry_common']['vcap']['install_path'] do
  repository        node['cloudfoundry_common']['vcap']['repo']
  reference         node['cloudfoundry_common']['vcap']['reference']
  user              node['cloudfoundry_common']['user']
  enable_submodules true
  action :sync
end
