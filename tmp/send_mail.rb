require File.join '..', './bootstrap'


Mail.defaults do
  delivery_method :smtp, address: 'localhost', port: 1025
end


mail = Mail.new do
  from    'alert@ip9.io'
  to      'test@gmail.com'
  subject 'Alert : Error with save my pocket'
  body    'Test mail'
end
mail.header['Content-Type'] = 'text/plain; charset=UTF-8'

puts mail.to_s

mail.deliver!

