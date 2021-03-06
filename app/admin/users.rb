ActiveAdmin.register User do
  menu :priority => 2
  config.per_page = 10
  

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :phno
      f.input   "add1"
      f.input   "add2"
      f.input   "state"
      f.input   "city"
      f.input   "zipcode"
    end
    f.actions
  end 
  index do
    column "Full Name", :name
    column "subscription",:product
    column "Package", :package_price_admin, :sortable=>false
    column :email
    column "Phone No",:phno
    column :city
    column :state
    
    default_actions
  end


  filter :name, :label=>"Full Name"
  filter :php, :label=>"Phone No"
  filter :email
  filter :city
  filter :state
  filter :zipcode
  filter :created_at
  filter :current_sign_in_ip


 
#  config.clear_action_items!
#  member_action :status do
#    @users = User.all
#    #@tours = Tour.order(params[:sort]+" "+params[:direction])
#    @tours = Tour.order("#{params[:sort] ||= 'status'} #{params[:direction] ||= 'desc'}")
#    @payments = Payment.find(:all,:order=>'created_at DESC')
#    #@u = User.find(params[:id])
#    @app_size= User::appliction_size
#    # This will render app/views/admin/posts/comments.html.erb
#  end
#  menu :label => "Status Report" ,:url=> '/admin/users/status/status'
end
