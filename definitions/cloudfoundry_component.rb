define :cloudfoundry_component do
  include_recipe "bluepill"
  include_recipe "logrotate"
  include_recipe "cloudfoundry-common"
  include_recipe "cloudfoundry-common::vcap"

  component_name = "cloudfoundry-#{params[:name]}"

  ruby_path    = File.join(rbenv_root, "versions", node.cloudfoundry_common.ruby_1_9_2_version, "bin")
  config_file  = params[:config_file] || File.join(node.cloudfoundry_common.config_dir, "#{params[:name]}.yml")
  bin_file     = params[:bin_file] || File.join(node.cloudfoundry_common.vcap.install_path, "bin", params[:name])
  install_path = params[:install_path] || File.join(node.cloudfoundry_common.vcap.install_path, params[:name])
  pid_file     = params[:pid_file] || File.join(node["cloudfoundry_#{params[:name]}"].pid_file)
  log_file     = params[:log_file] || File.join(node["cloudfoundry_#{params[:name]}"].log_file)

  rbenv_gem "bundler" do
    ruby_version node.cloudfoundry_common.ruby_1_9_2_version
  end

  bash "install #{component_name} gems" do
    user node.cloudfoundry_common.user
    cwd  install_path
    code "#{File.join(ruby_path, "bundle")} install --without=test --local"
  end

  template config_file do
    source   "#{params[:name]}-config.yml.erb"
    owner    node.cloudfoundry_common.user
    mode     "0644"
    notifies :restart, "bluepill_service[#{component_name}]"
  end

  template File.join(node.bluepill.conf_dir, "#{component_name}.pill") do
    cookbook "cloudfoundry-common"
    source "cloudfoundry_component.pill.erb"
    variables(
      :component_name => component_name,
      :path        => ruby_path,
      :binary      => "#{File.join(ruby_path, "ruby")} #{bin_file}",
      :pid_file    => pid_file,
      :config_file => config_file
    )
    notifies :reload, "bluepill_service[#{component_name}]"
  end

  bluepill_service component_name do
    action [:enable, :load, :start]
  end

  logrotate_app component_name do
    cookbook "logrotate"
    path log_file
    frequency daily
    rotate 30
    create "644 root root"
  end
end
