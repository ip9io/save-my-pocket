#
# Mail Helper
#
class MailHelper

  def self.send(title, msg)
    mail = Mail.new do
      from    MAIL_SEND_FROM
      to      MAIL_SEND_TO
      subject title
      body    msg
    end
    mail.header['Content-Type'] = 'text/plain; charset=UTF-8'
    mail.deliver!
  end

end

