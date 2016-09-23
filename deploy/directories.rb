include_recipe "deploy"

node['deploy'].each do |application, deploy|
  if deploy[:directories]
    deploy[:directories].each do |name, dir|

      directory dir do
        owner     deploy[:user]
        group     deploy[:group]
        mode      0770
        recursive true
        action    :create
      end

      opsworks_deploy_dir do
        user  deploy[:user]
        group deploy[:group]
        path  deploy[:deploy_to]
      end

      directory "#{deploy[:deploy_to]}/shared/#{name}" do
        action :delete
        recursive true
      end

      link "#{deploy[:deploy_to]}/shared/#{name}" do
        to dir
      end

    end
  end
end
