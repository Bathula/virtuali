ActiveAdmin.register Coupon,:as=>"Promotions" do
 menu :label => "Promotions",:priority => 4
 config.per_page = 10
  index do
    selectable_column
    column :code
    column "Company Name",:company
    column :email
    column :value
    column "Last Reemeded", :expire_date
    column "Valid until", :valid_date
    default_actions
  end
    
  form do |f|
    f.inputs "Coupon Details" do
      f.input :company
      f.input :expire_date
      f.input :valid_date
      f.input :company_email
      f.input :value

    end
    f.actions
  end
end
