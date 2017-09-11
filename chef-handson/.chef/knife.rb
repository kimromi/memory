local_mode true
cookbook_path ["cookbooks", "vendor/cookbooks"]
role_path     "roles"
data_bag_path "data_bags"
#encrypted_data_bag_secret "secret_data_bag_key"

knife[:use_sudo] = true
knife[:ssh_user] = 'vagrant'
