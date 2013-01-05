require 'net/http'
require 'json'

class HomeController < ApplicationController
    include HomeHelper
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
        res = get_commits_assembla(@to)
        @res = res
        respond_to do |format|
            format.json {render :json => @res }
        end
        
    end


    def users
        url = "https://api.assembla.com/v1/spaces.json"
        res = get_from_api url
        @spaces = JSON.parse res
        @space_ids = []
        @users = []
        @spaces.each do |space|
            @space_ids += [space['id']]
            url = "https://api.assembla.com/v1/spaces/#{space['id']}/user_roles.json"
            res = get_from_api url
            res = JSON.parse res
            res.each do |user_role|
                @users += [user_role['user_id']]

            end
        end

        @users = @users.uniq
        @required_users = []
        #if User.all().length == 0
            #generate and save to db if not already in db

        @users.each do |user|
            url = "https://api.assembla.com/v1/users/#{user}.json"
            res = get_from_api url
            res = JSON.parse res
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
        @tickets = get_tickets_assembla 
        respond_to do |format|
            format.json {render :json => @tickets}
        end
        
    end
end
