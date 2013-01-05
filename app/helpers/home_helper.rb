module HomeHelper
    def get_commits_assembla(date)
        url = "https://api.assembla.com/v1/activity.json?to=#{date}"
        res = get_from_api url
        res.body

    end

    def get_from_api(url)
        api_key = ENV["ASSEMBLA_API_KEY"]
        api_key_secret = ENV["ASSEMBLA_API_SECRET"]
        uri = URI(url)
        req = Net::HTTP::Get.new(uri.request_uri)
        req.add_field 'X-Api-Key', api_key
        req.add_field 'X-Api-Secret', api_key_secret
        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') { |http|
            http.request(req)
        }
        res
    end
end
