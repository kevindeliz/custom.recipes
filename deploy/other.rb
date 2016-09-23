include_recipe "deploy"

node['deploy'].each do |application, deploy|
  if deploy[:application_type] != 'other' || deploy['environment_variables']['OPSWORKS_APPLICATION_SUBTYPE']
    Chef::Log.debug("Skipping deploy::other application #{application} as it is not an 'other' app without subtype")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  execute "build_depedencies_for_#{application}" do
    cwd "#{deploy['deploy_to']}/current"
    command "make"
    only_if { ::File.exists?("#{deploy['deploy_to']}/current/Makefile") }
  end

end
