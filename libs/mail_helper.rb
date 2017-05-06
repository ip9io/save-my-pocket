#
# Mail Helper
#
class MailHelper

  def self.send(title, msg)
    mail = Mail.new do
      from    'alert@ip9.io'
      to      'test@gmail.com'
      subject title
      body    msg
    end
    mail.header['Content-Type'] = 'text/plain; charset=UTF-8'
    mail.deliver!
  end

end