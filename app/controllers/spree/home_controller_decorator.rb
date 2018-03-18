Spree::HomeController.class_eval do
  def index
    @contact = ContactForm.new(params[:home])
  end

  def contact_us
    @contact = ContactForm.new(params[:home])
    @contact.request = request
    binding.pry
    respond_to do |format|
      if @contact.deliver
        @contact = ContactForm.new
        format.html { render 'index'}
        format.js   { flash.now[:success] = @message = "Thank you for your message. I'll get back to you soon!" }
      else
        format.html { render 'index' }
        format.js   { flash.now[:error] = @message = "Message did not send." }
      end
    end
  end
end
