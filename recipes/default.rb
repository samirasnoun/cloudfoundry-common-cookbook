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


  n_nodes = search(:node, "role:cloudfoundry_nats_server_2")
  n_node = n_nodes.first
  
  node.set[:cloudfoundry_common][:nats_server][:host] = n_node.ipaddress


include_recipe "apt"
include_recipe "cloudfoundry-common::directories"
include_recipe "cloudfoundry-common::ruby_1_9_2"
