class SessionsController < Devise::SessionsController
  respond_to :html, :json
  def create
    print 'authenticating'
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    print 'hi'
    print resource
    print current_user

    respond_with do |format|
      format.html do
        respond_with resource, :location => redirect_location(resource_name, resource)
      end
      format.json do
        render :json => { :status => 'success', :token => current_user.authentication_token, :uri => current_user.uri }
      end
    end
  end
end 
