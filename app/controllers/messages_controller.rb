class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)

    if @message.save
      SmsGateway.instance.fetch_from_database
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :number)
  end
end
