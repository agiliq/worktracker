require 'net/http'
require 'json'

class HomeController < ApplicationController
    def index
        respond_to do |format|
            format.html
        end

    end

    def login
        respond_to do |format|
            format.html
        end
    end

    def logout
        session.delete('warden.user.user.key')

        redirect_to '/'
    end

    def commits
        @to = params['date']
        api_key = ENV["ASSEMBLA_API_KEY"]
        api_key_secret = ENV["ASSEMBLA_API_SECRET"]
        uri = URI("https://api.assembla.com/v1/activity.json?to=#{@to}")
        #uri = URI("https://api.assembla.com/v1/activity.json")
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
        api_key = ENV["ASSEMBLA_API_KEY"]
        api_key_secret = ENV["ASSEMBLA_API_SECRET"]
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
        #if User.all().length == 0
            #generate and save to db if not already in db

        @users.each do |user|
            uri = URI("https://api.assembla.com/v1/users/#{user}.json")
            req = Net::HTTP::Get.new(uri.request_uri)
            req.add_field 'X-Api-Key', api_key
            req.add_field 'X-Api-Secret', api_key_secret
            res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') { |http|
                http.request(req)
            }
            res = JSON.parse res.body
            if res['picture'] == ""
                res['picture'] = "/assets/home/no_pic.jpg"
            end
            res.delete('im2')
            res.delete('im')
            res['assembla_id'] = res['id']
            res.delete('id')
            #User.new(res).save()

            @required_users += [res]
        end
        #else
        #    puts "---------------from db -------------------"
        #    # jst return from db.
        #    users = User.all()
        #    users.each do |user|
        #        @required_users += [user]
        #    end



        respond_to do |format|
            format.json {render :json => @required_users }
        end
        
    end

    def tickets
        api_key = ENV["ASSEMBLA_API_KEY"]
        api_key_secret = ENV["ASSEMBLA_API_SECRET"]
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
        @tickets = []
        @spaces.each do |space|
            @space_ids += [space['id']]
            uri = URI("https://api.assembla.com/v1/spaces/#{space['id']}/tickets.json")
            req = Net::HTTP::Get.new(uri.request_uri)
            req.add_field 'X-Api-Key', api_key
            req.add_field 'X-Api-Secret', api_key_secret
            res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') { |http|
                http.request(req)
            }
            if res.class == Net::HTTPOK
                res = JSON.parse res.body
                res.each do |eachticket|
                    eachticket['space_name'] = space['name']
                    @tickets.push eachticket
                end    
            end

        end

        respond_to do |format|
            format.json {render :json => @tickets}
        end
        
    end
end
