# To change this template, choose Tools | Templates
# and open the template in the editor.

class TourDestroy < Struct.new(:u_id)
  def perform
    user=User.find(u_id)
    user.tours_destroy
  end
end
