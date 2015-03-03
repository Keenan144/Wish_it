require '../spec_helper'
require 'faker'




describe 'wish it' do 
  include Rack::Test::Methods 

  def app
    Sinatra::Application
  end

  it "loads homepage" do
    get '/' 
    expect(last_response).to be_ok
    expect(last_response.body).to eq(:homepage)
  end
  
end
