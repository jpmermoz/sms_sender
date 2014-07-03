class SmsGateway
  include Singleton

  def cmd(param)
    @port.write("#{param}\r")
    wait
  end

  def connect_to_serialport
    begin
      @port = SerialPort.new('/dev/ttyUSB0', 9600)
    rescue
      begin
        @port = SerialPort.new('/dev/ttyUSB1', 9600)
      rescue
        @port = SerialPort.new('/dev/ttyUSB2', 9600)
      end
    end

    cmd("AT")
    cmd("AT+CMGF=1")
    @debug = true
  end

  def send_sms(message)
    connect_to_serialport
    cmd("AT+CMGS=\"#{message.number}\"")
    cmd("#{message.content[0..140]}#{26.chr}\r\r")
    sleep 3
    wait
    cmd("AT")
  end

  def wait
    buffer = ''
    while IO.select([@port], [], [], 0.25)
      chr = @port.getc.chr;
      print chr if @debug == true
      buffer += chr
    end
    buffer
  end

  def close
    @port.close
  end

  def fetch_from_database
    t = Thread.new do
      Message.where(sent_at: nil).each do |m|
        m.update_attribute(:sent_at, Time.now) if m.send_sms.include?("OK")
        close
      end
    end
  end
end
