require 'hipchat'
require 'singleton'

class HipchatMsg
  include Singleton
  attr_accessor :options, :hipchat_client

  instance.options = { user: ENV['HIPCHAT_USER'] || '<user>',
                       rooms: [ENV['HIPCHAT_ROOM'] || '<room>'],
                       token: ENV['HIPCHAT_TOKEN'] || '<hipchat_token'
  }
  instance.hipchat_client ||= HipChat::Client.new(instance.options[:token])

  def self.send(message, color = 'yellow')
    instance.msg message, color unless ENV['QUIET']
  end

  def msg(message, color)
    @options[:rooms].each do |room|
      begin
        hipchat_client[room].send(options[:user], message, { color: color })
      rescue => e
        puts e.message
        puts e.backtrace
      end
    end
  end
end
