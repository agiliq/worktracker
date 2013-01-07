namespace :db do
    task :update_users => [:github_users, :assembla_users] do
    end
    desc "Fetch and save Github users"
    task :github_users => :environment do
        include HomeHelper
        require ='json'
        url = "https://api.github.com/orgs/#{ENV['GITHUB_ORG']}/members"
        members = get_from_api url, 'GITHUB'
        members = JSON.parse members
        new_records = 0
        updated_records = 0
        for each_member in members
            url = "https://api.github.com/users/#{each_member['login']}"
            user_details = get_from_api url, 'GITHUB'
            user_details = JSON.parse user_details
            user = ApiProviderUser.where(:id_from_provider => user_details['id'])

            if user.length == 1
                user[0].update_attributes('id_from_provider' => user_details['id'],
                    'login' => user_details['login'], 'picture' => user_details['avatar_url'],
                    'name' => user_details['name'], 'api_provider_name' => 'GITHUB')
                updated_records += 1

                puts "Updating github user : #{user_details['login']}"
            elsif user.length == 0
                ApiProviderUser.new('id_from_provider' => user_details['id'],
                    'login' => user_details['login'], 'picture' => user_details['avatar_url'],
                    'name' => user_details['name'], 'api_provider_name' => 'GITHUB').save()
                new_records += 1
                puts "Creating github user : #{user_details['login']}"

            else
                puts "---Error : Multiple records found for github user : #{user_details['id_from_provider']} --- #{user_details['login']} -----"
            end
        end
        puts "------------------------------------"
        puts "New Github users: #{new_records}"
        puts "Updated Github users: #{updated_records}"
        puts "------------------------------------"
    end

    desc "Fetch and save from Assembla"
    task :assembla_users => :environment do
        include HomeHelper
        require 'json'
        url = "https://api.assembla.com/v1/spaces.json"
        spaces = get_from_api url, 'ASSEMBLA'
        spaces = JSON.parse spaces
        user_ids = []
        new_records = 0
        updated_records = 0
        for each_space in spaces
            url = "https://api.assembla.com/v1/spaces/#{each_space['id']}/users.json"
            space_users = get_from_api url, 'ASSEMBLA'
            space_users = JSON.parse space_users
            space_users.each do |space_user|
                if not user_ids.include?space_user['id']
                    user_ids += [space_user['id']]
                    user = ApiProviderUser.where(:id_from_provider => space_user['id'])

                    if user.length == 1
                        user[0].update_attributes('id_from_provider' => space_user['id'],
                            'login' => space_user['login'], 'picture' => space_user['avatar_url'],
                            'name' => space_user['name'], 'api_provider_name' => 'ASSEMBLA')
                        updated_records += 1

                        puts "Updating assembla user : #{space_user['login']}"
                    elsif user.length == 0
                        ApiProviderUser.new('id_from_provider' => space_user['id'],
                            'login' => space_user['login'], 'picture' => space_user['avatar_url'],
                            'name' => space_user['name'], 'api_provider_name' => 'ASSEMBLA').save()
                        new_records += 1
                        puts "Creating assembla user : #{space_user['login']}"

                    else
                        puts "---Error : Multiple records found for github user : #{space_user['id_from_provider']} --- #{space_user['login']} -----"
                    end
                end
            end
        end
        puts "------------------------------------"
        puts "New Assembla users : #{new_records}"
        puts "Updated Assembla users : #{updated_records}"
        puts "------------------------------------"



    end
end
