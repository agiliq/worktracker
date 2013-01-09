module CustomAdminHelper
    include ActionView::Helpers::TextHelper
    def link_remaining_users(api_provider_name)
        api_users = ApiProviderUser.where(:api_provider_name => api_provider_name)
        remaining_users = []
        api_users.each do |u|
            api_provider_name_lower = api_provider_name.downcase
            linked = CustomUser.where("#{api_provider_name_lower}_id" => u.id_from_provider)
            if linked.count == 0
                remaining_users += [u.id_from_provider]
                CustomUser.create("#{api_provider_name_lower}_id" => u.id_from_provider,
                    :login => u.login, :name => u.name, :picture => u.picture)
            end
        end
        puts "Linked remaining_users : #{remaining_users}"
        if remaining_users.length > 0
            flash[:notice] = "  #{pluralize(remaining_users.length, 'remaining user', 'remaining users')} from #{api_provider_name} linked successfully"
        else
            flash[:notice] = 'You might have already done this operation. None are linked now.'
        end




    end
end
