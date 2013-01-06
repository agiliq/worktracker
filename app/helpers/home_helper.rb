module HomeHelper
    def get_commits_assembla(date)
        url = "https://api.assembla.com/v1/activity.json?to=#{date}"
        res = get_from_api url, 'ASSEMBLA'

    end

    def get_from_api(url, api_provider)
        api_key = ENV[api_provider+"_API_KEY"]
        api_key_secret = ENV[api_provider+"_API_SECRET"]
        uri = URI(url)
        req = Net::HTTP::Get.new(uri.request_uri)
        req.add_field 'X-Api-Key', api_key
        req.add_field 'X-Api-Secret', api_key_secret
        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') { |http|
            http.request(req)
        }
        if res.class == Net::HTTPOK
            return res.body
        else
            return "{}"
        end
    end

    def get_tickets_assembla()
        url = "https://api.assembla.com/v1/spaces.json"
        res = get_from_api url, 'ASSEMBLA'
        @spaces = JSON.parse res
        @space_ids = []
        @users = []
        @tickets = []
        @spaces.each do |space|
            @space_ids += [space['id']]
            url = "https://api.assembla.com/v1/spaces/#{space['id']}/tickets.json"
            res = get_from_api url, 'ASSEMBLA'
            if res != ""
                res = JSON.parse res
                res.each do |eachticket|
                    eachticket['space_name'] = space['name']
                    @tickets.push eachticket
                end    
            end

        end
        @tickets


    end
end
