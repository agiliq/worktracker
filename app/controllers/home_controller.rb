require 'net/http'
require 'json'

class HomeController < ApplicationController
    def index
        respond_to do |format|
            format.html
        end

    end
    def commits
        @to = params['date']
        api_key = "c4b4880d9be58de788fa"
        api_key_secret = "a6a286adb6a4839606a37afdc46c1f0ae5557f25"
        uri = URI("https://api.assembla.com/v1/activity.json?to=#{@to}")
        req = Net::HTTP::Get.new(uri.request_uri)
        req.add_field 'X-Api-Key', api_key
        req.add_field 'X-Api-Secret', api_key_secret
        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') { |http|
            http.request(req)
        }
        @res = res.body
        respond_to do |format|
            format.json {render :json => @res }
        end
        
    end
    def users
        api_key = "c4b4880d9be58de788fa"
        api_key_secret = "a6a286adb6a4839606a37afdc46c1f0ae5557f25"
        uri = URI("https://api.assembla.com/v1/spaces.json")
        req = Net::HTTP::Get.new(uri.request_uri)
        req.add_field 'X-Api-Key', api_key
        req.add_field 'X-Api-Secret', api_key_secret
        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') { |http|
            http.request(req)
        }
        @spaces = JSON.parse res.body
        @space_ids = []
        @users = []
        @spaces.each do |space|
            @space_ids += [space['id']]
            uri = URI("https://api.assembla.com/v1/spaces/#{space['id']}/user_roles.json")
            req = Net::HTTP::Get.new(uri.request_uri)
            req.add_field 'X-Api-Key', api_key
            req.add_field 'X-Api-Secret', api_key_secret
            res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') { |http|
                http.request(req)
            }
            res = JSON.parse res.body
            res.each do |user_role|
                @users += [user_role['user_id']]

            end
        end

        @users = @users.uniq
        @required_users = []
        @users.each do |user|
            uri = URI("https://api.assembla.com/v1/users/#{user}.json")
            req = Net::HTTP::Get.new(uri.request_uri)
            req.add_field 'X-Api-Key', api_key
            req.add_field 'X-Api-Secret', api_key_secret
            res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') { |http|
                http.request(req)
            }
            res = JSON.parse res.body

            @required_users += [res]
            
        end


        respond_to do |format|
            format.json {render :json => @required_users }
        end
        
    end
end
