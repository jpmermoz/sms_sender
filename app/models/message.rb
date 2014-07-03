class Message < ActiveRecord::Base
  validates :number, :content, presence: true

  validates :number, length: { is: 10 }
  validate  :number_is_from_mendoza
  before_save :format_text
  
  def send_sms
    SmsGateway.instance.send_sms(self)    
  end

  private

  def number_is_from_mendoza
   self.errors.add(:number, "debe ser de Mendoza") if number[0,3] != "261"
  end
  def format_text
	self.content.length.times do |i|
	  self.content[i..i+1]="\n" if self.content[i]==":"
        end
  end	
end
