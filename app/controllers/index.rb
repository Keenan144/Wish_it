

# --------------------- LOGIN ------------------------- #

post '/login' do
 #finds user with that handle
  @user = User.find_by(email: params[:email])
 if @user && @user.authenticate(params[:password])
      session_set_current_user(@user)
      #redirect to their profile page
      redirect('/profile')
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

before do
  @system_url = "https://fathomless-cove-4366.herokuapp.com/"



  # @system_url = "http://localhost:9292/"
  # @client_id = "343095229210233"
  # @client_secret = "edb09cb95e4b734e93e3f0cf0508d0ac"


  session[:oauth] ||= {}
end

# --------------------------Restful Routes--------------------------- #
get '/' do
  # goes to view /index.erb

    http = Net::HTTP.new "graph.facebook.com", 443
    request = Net::HTTP::Get.new "/me?access_token=#{session[:oauth][:access_token]}"
    http.use_ssl = true
    response = http.request request
    @json = JSON.parse(response.body)
  erb :homepage
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

# ----------------------------------------------------- #

# ------------------------Facebook Oauth Calls ----------------------------- #



get "/request" do
  redirect "https://graph.facebook.com/oauth/authorize?client_id=#{ENV["CLIENT_ID"]}&redirect_uri=#{@system_url}callback"
end

get "/callback" do
  session[:oauth][:code] = params[:code]

  http = Net::HTTP.new "graph.facebook.com", 443
  request = Net::HTTP::Get.new "/oauth/access_token?client_id=#{ENV["CLIENT_ID"]}&redirect_uri=#{@system_url}callback&client_secret=#{ENV["CLIENT_SECRET"]}&code=#{session[:oauth][:code]}"
  http.use_ssl = true
  response = http.request request

  session[:oauth][:access_token] = CGI.parse(response.body)["access_token"][0]
  redirect "/"
end


get "/logout" do
  session[:oauth] = {}
  session[:current_user_id] = nil
  redirect "/"
end

enable :inline_templates










