##Chef::Log.warn("------------->")
#Chef::Log.warn("------------->" +node['cloudfoundry_common']['services_dir'] )

%w{config_dir log_dir pid_dir staging_cache_dir staging_manifests_dir tmpdir droplets_dir resources_dir platform_cache_dir services_dir}.each do |dir|


  directory node['cloudfoundry_common'][dir] do
   recursive true
   owner node['cloudfoundry_common']['user']
   mode  '0755'
 end


#Chef::Log.warn("testststst -------------- loudfoundry_common" +    node['cloudfoundry_common'][ dir ] + " 5555") 

end

 
