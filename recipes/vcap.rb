%w{unzip}.each do |pkg|
  package pkg do
    action :install
  end
end

git node['cloudfoundry_common']['vcap']['install_path'] do
  repository        node['cloudfoundry_common']['vcap']['repo']
  reference         node['cloudfoundry_common']['vcap']['reference']
  user              node['cloudfoundry_common']['user']
  enable_submodules true
#  action :sync
  action :nothing
end
