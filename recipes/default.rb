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
    
    cf_id_node = node['cloudfoundry_common']['cf_session']['cf_id']
    n_nodes_nats = search(:node, "role:cloudfoundry_nats_server AND cf_id:#{cf_id_node}" )
   
    while n_nodes_nats.count < 1 
        Chef::Log.warn("Waiting for nats .... I am sleeping 7 sec")
        sleep 7
        n_nodes_nats = search(:node, "role:cloudfoundry_nats_server AND cf_id:#{cf_id_node}")        
       end
    Chef::Log.warn("Nats server found i am saving it")
 
     k = n_nodes_nats.first
          node.set['cloudfoundry_common']['nats_server']['host'] = k['ipaddress']

     node.save 

     if platform?("ubuntu") 
     include_recipe "apt"
     include_recipe "cloudfoundry-common::directories"
     include_recipe "cloudfoundry-common::ruby_1_9_2"
     end

end
