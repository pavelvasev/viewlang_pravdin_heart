# https://github.com/pavelvasev/viewlang_pravdin_heart/tree/master/server

require 'rubygems'
require 'sinatra/base' # see http://www.sinatrarb.com/intro
require 'sinatra/contrib/all' # see https://github.com/sinatra/sinatra-contrib/
require 'json'

$port = ARGV[0] || 7000
$public = File.expand_path(Dir.pwd)
puts "public folder = #{$public}"
puts "http port = #{$port}"

class HeartApp < Sinatra::Base

  configure do
    register Sinatra::Reloader
  
    set :logging, true
    set :dump_errors, true
    set :port, $port
    set :static, true
    set :bind, '0.0.0.0'
    
#    set :public_folder, $public
  end
  
  before do
    #headers "Content-Type" => "text/html; charset=utf-8"
    headers "Access-Control-Allow-Origin" => "*"
  end
      

  helpers do
    def find_hearts
      res = []
      Dir.glob("**/coord.txt").each do |file|
        dir = File.dirname(file)
        if File.file?( File.join(dir,"triangles.txt") )
          res.push dir
        end
        puts file
      end
      res
    end
    
  end

 # helpers Sinatra::JSON

  get '/find/:what' do
     a = eval("find_#{params[:what]}") rescue []
     [params[:what],a].to_json
  end

  get '/' do
    "this is priznak server 0.11"  
  end
  
  get '/stop' do
    #abort
    Thread.new { sleep 1; Process.kill 'INT', Process.pid }
    halt 200
  end
  
  get "/*" do
    file_path = File.expand_path( File.join($public,request.path) )
    puts "external request to file_path=#{file_path}"
    if not file_path.start_with?( $public )
      return [500,"server error"]
    end
    if not File.file?( file_path )
      return [404,"file not found"]
    end
    send_file file_path
  end

  # запуск приложения. поскольку оно у нас класс, то вот так вот.
  run! if app_file == $0

end