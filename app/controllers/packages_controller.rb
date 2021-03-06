class PackagesController < ApplicationController
  def show
    product=Product.find(params["product"].to_i)
    @regular_packages=product.packages.where(:package_type=>1).order("regular_price ASC")
    @combo_packages=product.packages.where(:package_type=>2)
    render :layout => false
  end
  def total_value
    pkg=Package.find(params["package_id"].to_i)
    payment_type=choose_payment_type.to_i

    if payment_type==2 and !pkg.nil? and !pkg.special_price.nil?
      @value = pkg.special_price
    else
      @value = pkg.regular_price
    end
    @value = current_user.price_after_discount(@value) if !current_user.nil? and current_user.any_coupon?
    render :text=>@value
  end
  def upgrade_package
    unless current_user.multiple_products?
      @regular_packages=current_user.packages_for_upgarde(1)
      @combo_packages=current_user.packages_for_upgarde(2)
    else
      @products=current_user.subscribe_product_for_upgrade
      render :upgrade_combo_package
    end
  end
  def upgrade

    @token = params[:stripeToken]
    #@amount =(current_user.ajust_amount(params[:total_amount]).to_f*100).to_i
    @amount =amount_to_charge
    @email= current_user.email

    payment()
    add_coupon
    #current_user.coupon=(params[:user][:coupon]) if params.include?:user
    current_user.change_package(params[:package])
    flash[:notice]= "Successfully Changed Your Package"
    
    #    if current_user.selected_package.payment_period_type.to_i==2 then
    #      change_annual_plan
    #    else
    #      change_montly_plan
    #    end
    redirect_to root_url
  end
  def upgrade_combo
    @token = params[:stripeToken]
    #@amount =(current_user.ajust_amount(params[:total_amount]).to_f*100).to_i
    @amount =amount_to_charge
    @email= current_user.email
    payment()
    add_coupon
    current_user.change_product(params[:user][:product])
    current_user.change_package(params[:user][:package])
    redirect_to root_url
  end

  
  def destroy_user_package
    if current_user.any_cash_back
      current_user.cancel_annual_plan
      flash[:notice]="Sucessfully changed to monthly plan"
    else
      current_user.package_destroy
      flash[:notice]="Sucessfully Deleted Your Package and Related Tours"
    end
    redirect_to root_url
  end


  private
  def add_coupon
    if params.include?:user and params[:user].include?:coupon
      current_user.coupon=(params[:user][:coupon])
      current_user.add_coupon_transaction
    elsif current_user.any_coupon?
      current_user.add_coupon_transaction
    end
  end
  #  def change_montly_plan
  #      @token = params[:stripeToken]
  #      #@amount =(current_user.ajust_amount(params[:total_amount]).to_f*100).to_i
  #      @amount =(params[:total_amount].to_f*100).to_i
  #      @email= current_user.email
  #
  #      payment()
  #      current_user.upgrade_package(params[:package])
  #
  #  end
  #  def change_annual_plan
  #      current_user.change_to_montly_plan(params[:package])
  #  end
  def amount_to_charge
    if params.include?:user and params[:user].include?:coupon
      (params[:user][:coupon][:amount].to_f*100).to_i
      #current_user.coupon=(params[:user][:coupon])
    else
      (params[:total_amount].to_f*100).to_i
    end
  end

  def payment()
    #    if current_user.selected_package.payment_period_type==1
    #      if current_user.card.nil?
    #        stripe_charge
    #      else
    #        change_plan
    #
    #      end
    #    else
    #      stripe_charge
    #    end
    stripe_charge

  end
  def change_plan

    cu = Stripe::Customer.retrieve(get_stripe_customer_id)
    #    plan_id=cu.subscription.plan.id
    plan= Stripe::Plan.create(
      :amount => @amount,
      :interval => 'month',
      :name => @email,
      :currency => 'usd',
      :id => @token)
    cu.subscription.plan.delete
    cu.description = "Customer for test@example.com"
    cu.plan=plan # obtained with Stripe.js
    cu.save
   
  end
  def choose_payment_type
    if params.include?"type_of_payment"
      params["type_of_payment"]
    elsif !current_user.nil?
      current_user.selected_package.payment_period_type
    else
      2
    end
  end

end
