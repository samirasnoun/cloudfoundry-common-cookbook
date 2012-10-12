#
# Cookbook Name:: cloudfoundry-common
# Recipe:: default
#
# Copyright 2012, Trotter Cashion
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
if Chef::Config[:solo]
     Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
    # n_nodes_nats = search(:node, "role:cloudfoundry_nats_server")
    n_nodes_nats = search(:node, "role:cloudfoundry_nats_server AND chef_environment:dev_version6" )
     if (n_nodes_nats.count > 0) then
     n_nodes_nats.each {|k|
       if (k['nats_server']['cf_session']['id'] == node['cloudfoundry_common']['cf_session']['id']) then
          node.set['cloudfoundry_common']['nats_server']['host'] = k['ipaddress']
       end
     }
     else(node['cloudfoundry_common']['nats_server']['host']  == nil )  
        Chef::Log.warn("No nats servers found for this cloud foundry session =  " + node.ipaddress)
     end 

     include_recipe "apt"
     include_recipe "cloudfoundry-common::directories"
     include_recipe "cloudfoundry-common::ruby_1_9_2"
end

