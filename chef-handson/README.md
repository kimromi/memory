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

gem 'chef'
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

```
cookbook_path ["cookbooks", "vendor/cookbooks"]
role_path     "roles"
data_bag_path "data_bags"
#encrypted_data_bag_secret "secret_data_bag_key"

knife[:use_sudo] = true
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
