include_recipe "deploy"

node['deploy'].each do |application, deploy|

  if deploy[:application_type] != 'other' || deploy['environment_variables']['OPSWORKS_APPLICATION_SUBTYPE']
    Chef::Log.debug("Skipping deploy::other application #{application} as it is not an 'other' app without subtype")
    next
  end

  directory "directory_#{deploy[:deploy_to]}" do
    path deploy[:deploy_to]
    recursive true
    action :delete

    only_if do
      File.exists?(deploy[:deploy_to])
    end
  end

end
