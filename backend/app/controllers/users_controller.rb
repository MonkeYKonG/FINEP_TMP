class UsersController < ApplicationController
    def sign_up
        @new_user = User.new
        if params[:Action] == "signup"
            if params[:email] && params[:firstname] && params[:name] && params[:pseudo] && params[:passwd] && params[:email] != "" && params[:firstname] != "" && params[:name] != "" && params[:pseudo] != "" && params[:passwd] != ""
                @new_user.email = params[:email]
                @new_user.firstname = params[:firstname]
                @new_user.name = params[:name]
                @new_user.pseudo = params[:pseudo]
                @new_user.capital = 0
                @new_user.passwd = params[:passwd]
                @new_user.open = false
                if !User.exists?(:pseudo => @new_user.pseudo) && !User.exists?(:email => @new_user.email)
                    if @new_user.save
                        render :status => 201, :json => @new_user and return
                    else
                        render :status => 500 and return
                    end
                else
                    render :status => 403 and return
                end
            else
                render :status => 400 and return
            end
        else
            render :status => 404 and return
        end
    end

    def sign_in
        if params[:Action] == "signin"
            if params[:email] && params[:passwd] && params[:email] != "" && params[:passwd] != ""
                @user = User.where(email: params[:email], passwd: params[:passwd])
                if @user && @user.size == 1
                    render :status => 201, :json => @user and return
                elsif @user && @user.size == 0
                    render :status => 400 and return
                else
                    render :status => 500 and return
                end
            else
                render :status => 400 and return
            end
        else
            render :status => 404 and return
        end
    end

    def forgot_passwd
        if params[:Action] == "lostpasswd"
            if params[:email] && params[:email] != ""
                bool = User.exists?(:email => params[:email])
                if bool
                    user = User.find_by_email(params[:email])
                    user.send_new_password if user
                    render :status => 201 and return
                elsif !bool
                    render :status => 400 and return
                else
                    render :status => 500 and return
                end
            else
                render :status => 400
            end
        else
            render :status => 404 and return
        end
    end

    def get_profiles
        render json: User.all
    end

    def update_profile
        if params[:Action] === "updateprofile"
            if params[:id] && params[:datas] && params[:values]
                @ret_users = User.find(params[:id])
                if @ret_users != nil
                    l = params[:datas].length
                    x = 0
                    while x < l
                        @ret_users[params[:datas][x]] = params[:values][x]
                        x += 1
                    end
                    if @ret_users.save
                        render :status => 201, :json => @ret_users and return
                    else
                        render :status => 500 and return
                    end
                else
                    render :status => 400 and return
                end
            else
                render :status => 400 and return
            end
        else
            render :status => 404 and return
        end
    end

    def get_info
        if params[:Action] === "profileinfo"
            if params[:users] && params[:datas]
                @ret_users = User.select([:id] + params[:datas]).where(id: params[:users])
                render status: 200, json: @ret_users and return
            else
              render :status => 400 and return
            end
        else
          render :status => 404 and return
        end
    end
end