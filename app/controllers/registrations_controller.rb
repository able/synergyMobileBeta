# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::InternalHelpers
  respond_to :json, :html
  def new
    super
  end
  def new_liveLinkID
    resource = build_resource({})
    resource[:liveLinkID] = params[:liveLinkID] 
    respond_with_navigational(resource){ render_with_scope :new }
  end
  def create2
    group = params[:user]['group'].downcase
    
    uri = group + '/' + params[:user]['username']
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
	respond_to do |format|
	  format.html { 
            respond_with resource, :location => redirect_location(resource_name, resource)
	  }
	  format.json { 
	    render :json => {'status' => 'success', 'token' => current_user.authentication_token, 'uri' => uri.downcase}
	  }
	end
      else
        set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
      tokens = group.split("/")
      ancestors = tokens[1,tokens.length-1] 
      parent = tokens[tokens.length-1]
      current_user = resource
      current_user.ancestors = ancestors
      current_user.parent = parent
      uri = current_user.group + '/' + current_user.username.downcase
      current_user['uri'] = uri
      current_user.friends << current_user 
      e1 = Entity.where(:name => "kitchen-room")[0]
      e2 = Entity.where(:name => "kitchen-msra-light-1195")[0]
      e3 = Entity.where(:name => "kitchen-coffee-machine")[0]
      e4 = Entity.where(:name => "kitchen-refrigerator")[0]
      e5 = Entity.where(:name => 'sms-gateway')[0]

      current_user.entities << e1
      current_user.entities << e2
      current_user.entities << e3
      current_user.entities << e4
      current_user.entities << e5

      current_user.reset_authentication_token!

      current_user.save!
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end


  def create
    print 'important params'
    print params
    # add custom create logic here
    group = params[:user]['group'].downcase
    
    uri = group + '/' + params[:user]['username'].downcase
    build_resource

    print 'just built resource'
    if resource.save
      if resource.active_for_authentication?
        print 'in active'
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
	respond_to do |format|
	  format.html { 
            respond_with resource, :location => redirect_location(resource_name, resource)
	  }
	  format.json { 
	    render :json => {'status' => 'success', 'token' => current_user.authentication_token, 'uri' => uri.downcase}
	  }
	end
      else
        set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
      tokens = group.split("/")
      ancestors = tokens[1,tokens.length-1] 
      parent = tokens[tokens.length-1]
      current_user = resource
      current_user.ancestors = ancestors
      current_user.parent = parent
      uri = current_user.group + '/' + current_user.username.downcase
      current_user['uri'] = uri
      current_user.friends << current_user 
      print current_user.uri

      print resource.errors
      e1 = Entity.where(:name => "kitchen-room")[0]
      e2 = Entity.where(:name => "kitchen-msra-light-1195")[0]
      e3 = Entity.where(:name => "kitchen-coffee-machine")[0]
      e4 = Entity.where(:name => "kitchen-refrigerator")[0]
      e5 = Entity.where(:name => 'sms-gateway')[0]

      current_user.entities << e1
      current_user.entities << e2
      current_user.entities << e3
      current_user.entities << e4
      current_user.entities << e5

      current_user.reset_authentication_token!

      current_user.save!
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end

  def update
    super
  end
end
