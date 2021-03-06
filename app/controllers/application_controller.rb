class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_user!
  
  
 rescue_from Stripe::CardError do |exception|
   #render :text=>exception.inspect
 flash[:error]=exception.message
 redirect_to :back
  end
rescue_from Stripe::InvalidRequestError do |exception|
  #render :text=> exception.inspect
  flash[:error]= exception.message
  redirect_to :back
end

def verify_account_validity
  unless current_user.nil?
    unless current_user.account_valid
     flash[:error]="Your account as either exipered or cancled by You. Buy new package to continue..  "
      redirect_to :action=>"upgrade_package",:controller=>"packages"
    end
  end
end


  private
  def stripe_charge
    @charge = Stripe::Charge.create(
      :amount => @amount, # amount in cents, again
      :currency => "usd",
      :card => @token,
      :description => @email
    )
    current_user.save_payment_details(@charge["id"],1,@charge[:amount]) unless current_user.nil?
  end

  def save_stripe_customer_id(user, customer)
    user.card=Card.create(:customer_stripe_id=>customer)
  end

  def get_stripe_customer_id
    current_user.card.customer_stripe_id
  end

  def subscription
  plan= Stripe::Plan.create(
  :amount => @amount,
  :interval => 'month',
  :name => @email,
  :currency => 'usd',
  :id => @token)

   @customer = Stripe::Customer.create(
      :card => @token,
      :plan => plan.id,
      :email => @email )
     save_stripe_customer_id(current_user, @customer.id) unless current_user.nil?

  end

  def unsubscribe
    customer_id=get_stripe_customer_id
    cu= Stripe::Customer.retrieve(customer_id)
    if cu.cancel_subscription
      Card.find_by_customer_stripe_id(get_stripe_customer_id).destroy
      "Your Direct Debit has been cancelled Successfully. Kindly refresh your page to reflect changes."
    else
      "For some reason, we are unable to cancel your Direct Debit. Try some other time. Sorry for inconvience. "
    end
  end
  def save_card_reuse
    @customer = Stripe::Customer.create(
      :card => @token,
      :description => @email
    )
    save_stripe_customer_id(@user, @customer.id)
    @charge = Stripe::Charge.create(
      :amount => @amount, # in cents
      :currency => "usd",
      :customer => @customer.id
    )

  end

  def use_previous_card
    @charge = Stripe::Charge.create(
      :amount => @amount, # in cents
      :currency => "usd",
      :customer => get_stripe_customer_id
    )
  end

end
