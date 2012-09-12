%w{unzip}.each do |pkg|
  package pkg do
    action :install
  end
end



bash "make vcap local copy from local http repo" do
  user "root" 
  cwd "/srv" 
  code <<-EOH
  wget http://10.1.1.241/master -O vcap_zip
  unzip vcap_zip
  mkdir vcap
  mv ./`ls | grep cloudfoundry-vcap*`/* ./vcap
  rm -rf ./`ls | grep cloudfoundry-vcap*`
  rm vcap_zip
  EOH
# not_if {"ls /srv/vcap/dev_setup" }

end


git node['cloudfoundry_common']['vcap']['install_path'] do
  repository        node['cloudfoundry_common']['vcap']['repo']
  reference         node['cloudfoundry_common']['vcap']['reference']
  user              node['cloudfoundry_common']['user']
  enable_submodules true
  action :sync
end
