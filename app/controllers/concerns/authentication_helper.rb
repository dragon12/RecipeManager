module AuthenticationHelper
  extend ActiveSupport::Concern

  included do
       http_basic_authenticate_with name: "gers", 
                                password: "myrecipes", 
                                except: [:index, :show]
  
 
  end

end