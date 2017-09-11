# Chef Hands-on!

## 前準備

下記をインストール

* VirtualBox
* Vagrant
* ruby >= 2.4

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

```json
{
  "name": "ruby",
  "description": "install ruby",
  "default_attributes": {
    "rbenv": {
      "rubies": [
        "2.4.1"
      ],
      "global": "2.4.1"
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
