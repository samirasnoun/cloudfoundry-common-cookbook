
%w{config_dir log_dir pid_dir staging_cache_dir staging_manifests_dir tmpdir droplets_dir resources_dir platform_cache_dir services_dir}.each do |dir|


  directory node['cloudfoundry_common'][dir] do
   recursive true
   owner node['cloudfoundry_common']['user']
   mode  '0755'
 end

end

 
