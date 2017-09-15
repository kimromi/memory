# Chef Hands-on!

## 前準備

下記をインストール

* VirtualBox
* Vagrant
* ruby = 2.4.1

## 準備

適当にディレクトリを作ってください

```
$ mkdir chef-handson
$ cd chef-handson
```

Gemfile

```ruby
# frozen_string_literal: true
source "https://rubygems.org"

gem 'chef', '~> 12.21.4'   # Chef13だとうまく動かないので今回12で...
gem 'knife-zero'
```

```
$ bundle install --path vendor/bundle
$ bundle exec chef-client -v
$ bundle exec knife -v
$ mkdir cookbooks environments data_bags roles nodes
```

こんな感じのディレクトリ構成になる

```tree
├── Gemfile
├── Gemfile.lock
├── cookbooks
├── data_bags
├── environments
├── nodes
├── roles
└── vendor
```

Vagrantfile作って

```ruby
# -*- coding: utf-8; mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.2"
  config.vm.hostname = "chef1.example"
  config.vm.network :private_network, ip: "192.168.33.99"  # 今回のサーバーIP
end
```

```sh
$ vagrant up
$ vagrant ssh-config --host 192.168.33.99 >> ~/.ssh/config
$ ssh 192.168.33.99
```

sshできた？

## .chef/knife.rb

```sh
$ mkdir .chef
$ touch .chef/knife.rb
```

.chef/knife.rb

```ruby
local_mode true
cookbook_path ["cookbooks", "vendor/cookbooks"]
role_path     "roles"
data_bag_path "data_bags"
#encrypted_data_bag_secret "secret_data_bag_key"

knife[:use_sudo] = true
knife[:ssh_user] = 'vagrant'
```

## knife zero bootstrap <host>

サーバー側にchef-clientをインストールしてくれて、以降Chefをあてられるようになる。  
nodes/ 以下に.jsonファイルができサーバーの適用された設定が格納されていく。

```sh
$ bundle exec knife zero bootstrap 192.168.33.99
```

```sh
$ ssh 192.168.33.99
$ chef-client -v
Chef: 13.3.42
```

## knife zero converge

サーバーに実際にChefを適用するコマンド。今のところまだcookbookがないので何も適用されない。

```sh
$ bundle exec knife zero converge 'name:chef1.example' -a knife_zero.host

192.168.33.99 Starting Chef Client, version 13.3.42
192.168.33.99 resolving cookbooks for run list: []
192.168.33.99 Synchronizing Cookbooks:
192.168.33.99 Installing Cookbook Gems:
192.168.33.99 Compiling Cookbooks...
192.168.33.99 [2017-09-11T08:29:52+00:00] WARN: Node chef1.example has an empty run list.
192.168.33.99 Converging 0 resources
192.168.33.99
192.168.33.99 Running handlers:
192.168.33.99 Running handlers complete
192.168.33.99 Chef Client finished, 0/0 resources updated in 01 seconds
```

## Berkshelfで外部のcookbookを使おう

### Berkshelfのインストール

Gemfileに以下を追記してbundle install

```
gem 'berkshelf'
```

### Gitのcookbookをいれる

Berksfile

```
source "https://supermarket.chef.io"

cookbook 'git'
```

berks vendor <path>コマンドでいれる

```
$ bundle exec berks vendor vendor/cookbooks
```

### run listにレシピを追加

```sh
# bundle exec knife node run_list add <node> '<recipe>'

$ bundle exec knife node run_list add chef1.example 'recipe[git]'
chef1.example:
  run_list: recipe[git]
```

まだGitない

```sh
% ssh 192.168.33.99
Last login: Mon Sep 11 08:29:50 2017 from 10.0.2.2
[vagrant@chef1 ~]$ git
-bash: git: command not found
```

### convergeしてみる

```sh
$ bundle exec knife zero converge 'name:chef1.example' -a knife_zero.host
192.168.33.99 Starting Chef Client, version 13.3.42
192.168.33.99 resolving cookbooks for run list: ["git"]
192.168.33.99 Synchronizing Cookbooks:
192.168.33.99   - git (8.0.0)
192.168.33.99   - build-essential (8.0.3)
192.168.33.99   - homebrew (4.2.0)
192.168.33.99   - seven_zip (2.0.2)
192.168.33.99   - mingw (2.0.1)
192.168.33.99   - ohai (5.2.0)
192.168.33.99   - windows (3.1.2)
192.168.33.99 Installing Cookbook Gems:
192.168.33.99 Compiling Cookbooks...
192.168.33.99 Converging 1 resources
192.168.33.99 Recipe: git::package
192.168.33.99   * git_client[default] action install
192.168.33.99     * yum_package[default :create git] action install
192.168.33.99       - install version 1.8.3.1-6.el7_2.1 of package git
192.168.33.99
192.168.33.99
192.168.33.99 Running handlers:
192.168.33.99 Running handlers complete
192.168.33.99 Chef Client finished, 2/2 resources updated in 16 seconds
```

Gitがインストールされた！

```sh
$ ssh 192.168.33.99
Last login: Mon Sep 11 10:03:45 2017 from 10.0.2.2
[vagrant@chef1 ~]$ git --version
git version 1.8.3.1
```

### その他

メジャーなcookbookのソースは[https://github.com/chef-cookbooks](https://github.com/chef-cookbooks)にある

## Railsをいれるぞ！

### rbenvをつかってRubyをいれてみよう

Berksfileに以下を追記して`bundle exec berks vendor vendor/cookbooks`する

```ruby
cookbook 'ruby_build'
cookbook 'ruby_rbenv', '~> 1.2.0'
```

#### Roleを作成しよう

```
$ bundle exec knife role create ruby
```

エディタが立ち上がるので以下のように修正してください

エディタが立ち上がらないときは`export EDITOR=vim`とかでエディタを設定してください

```json
{
  "name": "ruby",
  "description": "install ruby",
  "default_attributes": {
    "rbenv": {
      "rubies": [
        "2.4.1"
      ],
      "global": "2.4.1",
      "gems": {
        "2.4.1": [
          {
            "name": "bundler"
          }
        ]
      }
    }
  },
  "run_list": [
    "recipe[ruby_build]",
    "recipe[ruby_rbenv::system]"
  ]
}
```

#### run listにroleを追加してconverge

```sh
$ bundle exec knife node run_list add chef1.example 'role[ruby]'
chef1.example:
  run_list:
    recipe[git]
    role[ruby]
$ bundle exec knife zero converge 'name:chef1.example' -a knife_zero.host

...
```

Rubyはいった！

```sh
$ ssh 192.168.33.99
Last login: Mon Sep 11 12:10:45 2017 from 10.0.2.2
[vagrant@chef1 ~]$ ruby -v
ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
```

### Railsいれていく

Berksfileに以下を追記して`bundle exec berks vendor vendor/cookbooks`する

```ruby
cookbook 'yum-epel'
```

自作のcookbookを作成していきます

```sh
$ bundle exec knife cookbook create rails -o cookbooks
```

cookbooks/rails/ に色々ディレクトリができる


cookbooks/rails/recipes/default.rb

```ruby
include_recipe 'yum-epel'

# nginx
package 'nginx' do
  action :install
end
service 'nginx' do
  action [:enable, :start]
end

# for Rails
directory '/var/www/rails' do
  mode '775'
  owner 'vagrant'
  group 'vagrant'
  recursive true
end

# for sqlite3
package 'sqlite-devel'

# for uglifier
remote_file "#{Chef::Config[:file_cache_path]}/http-parser-2.7.1-3.el7.x86_64.rpm" do
  source "https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm"
  not_if "rpm -qa | grep -q '^http-parser'"
  action :create
  notifies :install, "rpm_package[http-parser]", :immediately
end
rpm_package "http-parser" do
  source "#{Chef::Config[:file_cache_path]}/http-parser-2.7.1-3.el7.x86_64.rpm"
  action :nothing
end
package 'nodejs'
```

run listを追加してconvergeする

```sh
$ bundle exec knife node run_list add chef1.example 'recipe[rails]'
chef1.example:
  run_list:
    recipe[git]
    role[ruby]
    recipe[rails]
$ bundle exec knife zero converge 'name:chef1.example' -a knife_zero.host
```

Nginx入った

```
$ nginx -v
nginx version: nginx/1.10.2
```

この時点で[http://192.168.33.99/](http://192.168.33.99/)にアクセスするとnginxが起動しているのがわかる！

### Railsアプリ

サンプルのRails(5.1.4)を用意しました。適当にcloneしてください  
https://github.com/kimromi/chef-handson-rails

```
$ bundle install --path vendor/bundle
$ bundle exec cap production deploy
```

鍵問題でデプロイ失敗するときは以下でssh-add

```sh
# vagrant上でgithub.comのcloneができるようにする
$ ssh-add ~/.ssh/[github.comに接続している秘密鍵]
```

puma起動した

```sh
$ ssh 192.168.33.99
Last login: Tue Sep 12 11:04:36 2017 from 10.0.2.2
[vagrant@chef1 ~]$ ps aux | grep pum[a]
vagrant  28104  0.6  6.3 574444 64780 ?        Sl   11:01   0:01 puma 3.10.0 (unix:///var/www/rails/shared/tmp/sockets/puma.sock)
```

### Nginxとpumaをつなぐ

cookbooks/rails/attributes/default.rb

```ruby
default['rails']['app_directory'] = '/var/www/rails'
default['rails']['fqdn'] = 'chef1.example'
```

cookbooks/rails/templates/default/chef1.exapmle.conf.erb

```ruby
upstream puma {
    server unix://<%= node['rails']['app_directory'] %>/shared/tmp/sockets/puma.sock;
}

server {
    listen       80;
    server_name  <%= node['rails']['fqdn'] %>;
    root         <%= node['rails']['app_directory'] %>/current/public;

    location / {
        try_files $uri $uri/index.html $uri.html @webapp;
    }

    location @webapp {
        proxy_read_timeout 300;
        proxy_connect_timeout 300;
        proxy_redirect off;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_pass http://puma;
    }
}
```

cookbooks/rails/recipes/default.rb に追記

```ruby
# chef1.example用のnginx設定
template "/etc/nginx/conf.d/chef1.example.conf" do
  source 'chef1.example.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[nginx]'
end
```

converge

```sh
$ bundle exec knife zero converge 'name:chef1.example' -a knife_zero.host
```


macの/etc/hosts

```
192.168.33.99 chef1.example
```

[http://chef1.example](http://chef1.example)でみれるのでは？

## environmentを設定してみよう

knife node environment setで設定できる

```sh
% bundle exec knife node environment set chef1.example production
chef1.example:
  chef_environment: production
```

production設定を追加する

```sh
% bundle exec knife environment create production
```

default_attributesに以下を追加

```json
  "default_attributes": {
    "rails": {
      "fqdn": "chef1.production"
    }
  }
```

こちらの方が設定が優先される

```sh
$ bundle exec knife zero converge 'name:chef1.example' -a knife_zero.host
...
192.168.33.99     -    server_name  chef1.example;
192.168.33.99     +    server_name  chef1.production;
```

/etc/hosts

```
192.168.33.99 chef1.production
```

[http://chef1.production/](http://chef1.production/)で見れるようになっている

### 参考: attributesの優先度

基本的に以下の順で下に行くほど優先度が高い

* cookbook attributes (cookbooks/rails/attributes/)
* recipe (cookbooks/rails/recipes/ ※`node.default['rails']['fqdn'] = 'chef1.recipe'`みたいな書き方)
* environments (environments/)
* roles (roles/)

[https://docs.chef.io/attributes.html#id1](https://docs.chef.io/attributes.html#id1)
