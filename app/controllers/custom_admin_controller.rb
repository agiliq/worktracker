class CustomAdminController < ApplicationController
    include CustomAdminHelper
    def index
        if request.method == 'POST'
            if not request.POST.has_key?('assembla_id')
                flash[:error] = 'Missing post parameter assembla_id. Contact admin.'
            elsif not request.POST.has_key?('github_id')
                flash[:error] = 'Missing post parameter github_id. Contact admin.'
            else
                assembla_id = request.POST['assembla_id']
                github_id = request.POST['github_id']
                assembla_user_details = ApiProviderUser.where(:id_from_provider => assembla_id, :api_provider_name => 'ASSEMBLA')
                github_user_details = ApiProviderUser.where(:id_from_provider => github_id, :api_provider_name => 'GITHUB')
                if assembla_user_details.count != 1
                    flash[:error] = 'Selected assembla user does not exist'
                    puts " -----------------------Assembla user does not exists ----------------"
                elsif github_user_details.count != 1
                    flash[:error] = 'Selected Github user does not exist'
                    puts " ----------------------Github user does not exists ----------------"
                else
                    assembla_linked_details = CustomUser.where(:assembla_id => assembla_id)
                    github_linked_details = CustomUser.where(:github_id => github_id)
                    if assembla_linked_details.count == 1
                        flash[:notice] = 'Selected assembla user already linked.'
                    elsif assembla_linked_details.count > 1
                        flash[:error] = "Something wrong, selected assembla user linked #{assembla_linked_details.count} times. Max only once. Rectify that."
                    elsif github_linked_details.count == 1
                        flash[:notice] = 'Selected github user already linked.'
                    elsif github_linked_details.count > 1
                        flash[:error] = "Something wrong, selected github user linked #{github_linked_details.count} times. Max only once. Rectify that."
                    else
                        github_user_details = github_user_details[0]
                        assembla_user_details = assembla_user_details[0]

                        picture = github_user_details.picture
                        assembla_pic = assembla_user_details.picture
                        if assembla_pic != nil
                            if assembla_pic.strip.length != 0
                                picture = assembla_user_details.picture
                            end
                        end

                        CustomUser.create(:assembla_id => assembla_id, :github_id => github_id, :login => assembla_user_details.login, :name => assembla_user_details.name,
                                         :picture => picture)
                        flash[:notice] = 'Selected users successfully linked.'
                    end
                end



            end

        end
        @assembla_users = ApiProviderUser.where(:api_provider_name => 'ASSEMBLA')
        @github_users = ApiProviderUser.where(:api_provider_name => 'GITHUB')
        linked_users = CustomUser.select('assembla_id, github_id')
        @linked_assembla_user_ids = []
        @linked_github_user_ids = []
        linked_users.each do |u|
            @linked_assembla_user_ids += [u.assembla_id]
            @linked_github_user_ids += [u.github_id]
        end


        respond_to do |format|
            format.html
            format.json {render :json => { :assembla_users => @assembla_users, :github_users => @github_users,
                :linked_ass_user_ids => @linked_assembla_user_ids, :linked_github_user_ids => @linked_github_user_ids} }
        end

    end

    def link_remaining_assembla_users()
        link_remaining_users('ASSEMBLA')
        redirect_to admin_home_path
    end
    def link_remaining_github_users()
        link_remaining_users('GITHUB')
        redirect_to admin_home_path
    end

end
