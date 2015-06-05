

# --------------------- LOGIN ------------------------- #

post '/login' do
 #finds user with that handle
  @user = User.find_by(email: params[:email])
 if @user && @user.authenticate(params[:password])
      session_set_current_user(@user)

      redirect('/')
  else

    @error = "invalid login"
  erb :help
 end
end


# ----------------------------------------------------- #



# --------------------- Register -------------------------------- #
# #registration page
get '/register' do
  erb :register
end

post '/register' do
  if User.find_by(email: params[:email]) == nil
  @new_user = User.create(name: params[:name], handle: params[:handle], password: params[:password], profile_picture: params[:profile_picture], email: params[:email])
    if @new_user.valid?
        session_set_current_user(@new_user)
        redirect('/profile')
    else
      erb :register
    end
  else
    @error = "that email is taken"
    erb :help
  end
end
# ----------------------------------------------------- #

# --------------------------Restful Routes--------------------------- #
get '/' do
  p "loading '/'"
  # goes to view /index.erb

  if session_current_user == nil
    p "session is nil"
    erb :"partials/_loginpage"
  else
    erb :homepage
  end
end

get '/friends' do 
  erb :"partials/_display_friends_list"
end

get '/searchFriends' do 
  erb :"partials/_search_friends"
end


get "/session" do
  session.inspect
end

get "/search" do
  @user = User.find_by(email: params[:email])
  if @user == nil
    @user = User.find_by(handle: params[:username])
  end
  @profile_id = @user.id
  erb :user_profile
end

get '/profile' do
  if session[:current_user_id] == nil
    @error = "you're not logged in"
    erb :help
  else
    erb :profile
  end
end

get '/user/:user_id/profile/:profile_id' do
  @user_id = params[:user_id]
  @profile_id = params[:profile_id]

  erb :user_profile
end

post '/user/:user_id/profile/:profile_id/add_friend' do

  @friend = Friend.create(friender_id: params[:user_id], friended_id: params[:profile_id])
end

put '/user/:user_id/edit' do 

  user = User.find(params[:user_id])
redirect '/profile'
end

get '/user/:user_id/friends' do 
  @friends = Friend.all
  @users = User.all

  erb :friends
end

get '/donate' do 

  erb :donate
end

get '/help' do 

  erb :help
end

get '/contact_info' do
  
  erb :contact_info, layout: false
end

post '/user/:user_id/wish' do
  #create a new wish
  @user = User.find(params[:user_id])
  @wish = @user.wishes.create(content: params[:content], url: params[:url], priority: params[:priority], user_id: session[:current_user_id])
  if @wish.valid?
    erb :_wishes, layout: false
  else
    @error = "Wish DID NOT pass validations: @user = #{@user}////// @wish = #{@wish}"
    erb :error
  end
end

get '/user/:user_id/wish/:wish_id' do 
  #display a specific wish
  @wish = Wish.find(params[:wish_id])
  @user = User.find(params[:user_id])


  erb :single_wish
end

get '/wishlistitem/:id/edit' do 

  #return html form for editing wish
end

put '/wishlistitem/:id' do
  #updates a specific wish
  
  redirect '/'
end


delete '/user/:user_id/wish/:wish_id/delete' do
  #delete a wish
  @wish = Wish.find(params[:wish_id])
  @wish.destroy
end


get "/request" do

end

get "/callback" do

  redirect "/"
end


get "/logout" do
  session[:current_user_id] = nil
  redirect "/"
end











