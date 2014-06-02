class Message < ActiveRecord::Base
  validates :number, :content, presence: true

  validates :number, length: { is: 10 }
  validate  :number_is_from_mendoza
  
  def send_sms
    SmsGateway.instance.send_sms(self)    
  end

  private

  def number_is_from_mendoza
   self.errors.add(:number, "debe ser de Mendoza") if number[0,3] != "261"
  end
end
