# https://github.com/pavelvasev/viewlang_pravdin_heart/tree/master/server

require 'rubygems'
require 'sinatra/base' # see http://www.sinatrarb.com/intro
require 'sinatra/contrib/all' # see https://github.com/sinatra/sinatra-contrib/
require 'json'
require 'webrick'

module WEBrick
  class HTTPRequest
      def keep_alive?
            false
       end
  end
end
                  


$port = ARGV[0] || 7000
$public = File.expand_path(Dir.pwd)
$scriptdir = File.expand_path(File.dirname(__FILE__))
puts "script folder = #{$scriptdir}"
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
    set :server, %w[webrick]
    #set :environment, :production
    
#    set :public_folder, $public

     mime_type :dat, 'text/plain'
  end
  
  before do
    #headers "Content-Type" => "text/html; charset=utf-8"
    headers "Access-Control-Allow-Origin" => "*"
    #puts "http request path: #{request.path}"
  end
  
  after do
    $stderr.flush
    $stdout.flush
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
     what = params[:what].tr("^a-z","-")
     a = eval("find_#{what}") rescue []
     [params[:what],a].to_json
  end

  get '/' do
    "this is priznak server 0.12"  
  end
  
  get '/stop' do
    #abort
    Thread.new { sleep 1; Process.kill 'INT', Process.pid }
    halt 200
  end
  
  def safepath(s)
    (s || "???").to_s.gsub(/[^a-zA-Z0-9\.\/\-_]/,"!")
  end
  
  def safeparam(a)
    safepath(params[a])
  end
  
  def ecgonly( ecgfilepath )

    tfile = safepath( File.basename( ecgfilepath ) )
    tdir = safepath( File.dirname( ecgfilepath ) )
    
    x=params[:x].to_i
    y=params[:y].to_i
    z=params[:z].to_i
    cmd = "cd #{tdir};#{File.join($scriptdir,'ecgonly/ECGonly')} #{tfile} #{x} #{y} #{z}"
    puts "calling cmd=#{cmd}"
    res = `#{cmd}`
    if res =~ /writing ECG to file ([^\n]+)/
       outfile = $1
       return File.join(tdir,outfile)
    else
       [500,"ecg output write failed. res = #{res}"]
    end 
  end
  
  get "/*" do
    file_path = File.expand_path( File.join($public,request.path) )
    puts "external request to file_path=#{file_path}"

    if not file_path.start_with?( $public+"/" )
      return [500,"server error"]
    end
    
    if not File.file?( file_path )
      return [404,"file not found"]
    end
    
    if params[:ecgonly] == "1"
      file_path = ecgonly(file_path)
    end
    
    if file_path.is_a?(String)
      if not File.file?( file_path )
        return [404,"output file not found"]
      end    
    
      if File.size( file_path ) > 500*1024*1024
        return [500,"file too big"]
      end
    
      send_file file_path
    else
      file_path # body?
    end  
  end

  # запуск приложения. поскольку оно у нас класс, то вот так вот.
  run! if app_file == $0

end