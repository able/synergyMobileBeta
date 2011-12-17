class RestController < ApplicationController
  respond_to :html, :json  


  before_filter :parse

  def find_entity_by_uri(uri)
    return Entity.where(:uri => uri)[0]
  end


 def actuation
    @entity = find_entity_by_uri('/' + params[:uri])
    @host = "127.0.0.1"
    @port = "8888"
    @path = "/" + params[:uri] + "/methods/" + params[:method]
    print @path
    request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' =>'application/json'})
    request.body = @body
    response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }
    puts "Response #{response.code} #{response.message}: #{response.body}"
    render :json => {"status" => response.message}
  end



  def parse
    x = params[:uri]
    if x
      if '.json' == (x [ x.length - 5, x.length])
        params[:uri] = x[0, x.length - 5 ]
      end
    end
  end

  def current_user
    return User.where(:authentication_token => params[:auth_token])[0]
  end


  def create_new_trigger
    current_user.triggers.create!(params[:trigger])
  end

  def my_things
    @prototypes = Prototype.all.where(:ancestors => 'thing').to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new
    
    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end
      
    @subtypes.each do |subtype| 
      entities = current_user.things.where(:subtype => subtype)
      arr = Array.new
      entities.each do |entity| 
        arr << entity.uri
      end
       
      if not arr.empty?
        @hash[subtype] = arr
      end
    end
  end
  def my_things
  
    respond_to do |format|
        format.json  { 
  	  hash = {:data => current_user.entities.where(:type => 'thing').to_a.collect! { |ent| 
			{:name => ent.uri, :description => ent.subtype } }}
  	  render :json => hash 
	
	}
    end
  end


  def my_spaces_
    respond_to do |format|
        format.json  { 
  	  hash = {:data => current_user.entities.where(:type => 'space').to_a.collect! { |ent| 
			{:name => ent.uri, :description => ent.subtype } }}
  	  render :json => hash 
	
	}
    end
  end


  def my_public_things
  
    respond_to do |format|
        format.json  { 
  	  hash = {:data => current_user.entities.where(:type => 'thing', :ownership => 'public' ).to_a.collect! { |ent| 
			{:name => ent.uri, :description => ent.subtype } }}
  	  render :json => hash 
	
	}
    end
  end


  def my_private_things
    respond_to do |format|
        format.json  { 
  	  hash = {:data => current_user.entities.where(:type => 'thing', :ownership => current_user.uri).to_a.collect! { |ent| 
			{:name => ent.uri, :description => ent.subtype } }}
  	  render :json => hash 
	
	}
    end
  end


  def my_public_spaces
    respond_to do |format|
        format.json  { 
  	  hash = {:data => current_user.entities.where(:type => 'space', :ownership => 'public').to_a.collect! { |ent| 
			{:name => ent.uri, :description => ent.subtype } }}
  	  render :json => hash 
	
	}
    end
  end


  def my_private_spaces
    respond_to do |format|
        format.json  { 
  	  hash = {:data => current_user.entities.where(:type => 'space', :ownership => current_user.uri).to_a.collect! { |ent| 
			{:name => ent.uri, :description => ent.subtype } }}
  	  render :json => hash 
	
	}
    end
  end


  def all_public_spaces
    respond_to do |format|
        format.json  { 
  	  hash = {:data => Entity.where(:type => 'space', :ownership => 'public').to_a.collect! { |ent| 
			{:name => ent.uri, :description => ent.subtype } }}
  	  render :json => hash 
	
	}
    end
  end

  def all_public_things
    respond_to do |format|
        format.json  { 
  	  hash = {:data => Entity.where(:type => 'thing', :ownership => 'public').to_a.collect! { |ent| 
			{:name => ent.uri, :description => ent.subtype } }}
  	  render :json => hash 
	
	}
    end
  end
  def all_space_subtypes
    respond_to do |format|
        format.json  { 
  	  hash = {:data => Prototype.where(:ancestors => 'space').to_a.collect! { |ent| 
			{:name => ent.name} }}
  	  render :json => hash 
	
	}
    end
  end 
  def all_thing_subtypes
    respond_to do |format|
        format.json  { 
  	  hash = {:data => Prototype.where(:ancestors => 'thing').to_a.collect! { |ent| 
			{:name => ent.name} }}
  	  render :json => hash 
	
	}
    end
  end 

  def add_existing_entity 
    @entity = find_entity_by_uri('/' + params[:uri])
    if current_user.entities.push @entity
      render :json => {"status" => "success", "data" => "Successfully added entity."}
    else
      render :json => {"status" => "failure", "data" => "Error"}
    end
  end
  
  def create_new_entity
    print params
    name = params['name'].gsub(/\s+/, "-").gsub(/[^\w-]/, "-").downcase
    livePulseID = params['livePulseID']
    type = params['type']
    uri = params['uri']
  
    @parent = Entity.where(:uri => uri)[0]
    if @parent.attribute_present?('coordinates')
      coordinates = @parent.coordinates
    else
      coordinates = ''
    end
    # parse the url, grab parents and ancestors
    tokens = uri.split("/")
    ancestors = tokens[1,tokens.length]
    parent = tokens[tokens.length-1]
    desc = params['description']
    ownership = params['ownership']
  
    print "CURRENT USER"
    print current_user.username 
    if ownership == 'private'
      # change this later when we figure out how to find the current logged in user.
      ownership = current_user.group + "/" + current_user.username
    end
    print ownership
    subtype = params['subtype']
    
    prototype = Prototype.where(name: subtype)[0]
    print prototype[0]
    
    @entity = current_user.entities.create(
      name: name,
      livePulseID: livePulseID,
      type: type,
      uri: uri,
      desc: desc,
      ancestors: ancestors,
      parent: parent,
      ownership: ownership,
      subtype: subtype,
      states: prototype['states'],
      methods: prototype['methods'],
      events: prototype['events'],
      coordinates: coordinates
    )
       
    if @entity.save!
      render :json => {"status" => "success", "data" => "Successfully created entity."}
    else
      render :json => {"status" => "failure", "data" => @entity.errors.to_s}
    end
  end

  def delete_entity
    @entity = find_entity_by_uri('/' + params[:uri]) 
    if @entity.ownership == 'public'
      if current_user.entities.delete @entity
        render :json => {"status" => "success", "data" => "Successfully deleted entity."}
      else
        render :json => {"status" => "failure", "data" => "Error"}
      end
    else
      if @entity.delete
        render :json => {"status" => "success", "data" => "Successfully deleted entity."}
      else
        render :json => {"status" => "failure", "data" => "Error"}
      end
    end
  end
 
  def current_user
    return User.where(:authentication_token => params[:auth_token])[0]
  end

  def view
    ent = Entity.where(:uri => '/' + params[:uri])
    print params[:uri]
    if ent.count == 0
      render :json => {"status" => "error, nothing found."}
    else
      ent = ent[0]#.delete('_id')
      hash = {}
      hash['uri'] = ent['uri']
      hash['events'] = ent['events']
      hash['methods'] = ent['methods']
      hash['name'] = ent['name']
      hash['ownership'] = ent['ownership']
      hash['type'] = ent['type']
      hash['subtype'] = ent['subtype']
      hash['description'] = ent['desc']
      hash['livePulseID'] = ent['livePulseID']
      hash['children'] = Entity.where(:ancestors => ent.name, :parent => ent.name).to_a.collect! { |e| e.uri}
      render :json => hash 
    end
  end

  def require_login 
    current_user = User.where(:authentication_token => params[:auth_token])[0]
    print current_user.name
  end
 
  def token
    email = params['user']['email']
    render :json => {'token' => User.where(:email => email)[0].authentication_token}
  end
    
  def turnOn
    @host = "http://127.0.0.1"
    @port = "8888"
    @path = "/" + params[:uri] + "/methods/turnOn"
    request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' =>'application/json'})
    request.body = @body
    response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }
    puts "Response #{response.code} #{response.message}: #{response.body}"
  end

  def turnOff
    @host = "http://127.0.0.1"
    @port = "8888"
    @path = "/" + params[:uri] + "/methods/turnOff"
    request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' =>'application/json'})
    request.body = @body
    response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }
    puts "Response #{response.code} #{response.message}: #{response.body}"
  end

  def coords
    data = Hash.new
    @entities = Entity.any_in(:subtype => ["cubicle", "focus-room", "mail-room", "office", "open-area", "phone-room", "conference-room", "kitchen" ])
#.where(:ancestors => "12")
    userArray = Array.new
    spaceArray = Array.new
    @entities.each do |entity|
      print entity.name
      array.push({:name => entity.name, :coordinates => entity.coordinates, :dimensions => entity.dimensions, :uri => entity.uri, :subtype => entity.subtype})
    end
    hash = Hash.new
    @friends = current_user.friends
    @friends.each do |friend|
      state = State.where(:type => 'currentOccupany', :entity_uri => friend.uri).any_in(:value => [friend.uri]).desc(:timestamp)[0]
      space = state.entity 
      hash[friend.name] = {:name => friend.name, :coordinates => space.coordinates, 
	:time => state.timestamp }
    end
    render :json => data 
  end

  def update_form_add_new_trigger
    ent = Entity.where(:uri => params[:url])[0]
    respond_to do |format| 
      format.json {render :json => ent}
    end
  end
 
  def view_my_friends 
    render :json => {:data => current_user.friends.all.to_a.collect! { | friend | {:name => friend.uri, :group => friend.group, :email => friend.email, :phone_number => friend.phone_number } } }
  end

  def list_all_users 
     render :json => {:data => User.all.to_a.collect! { | friend | {:name => friend.uri, :group => friend.group, :email => friend.email, :phone_number => friend.phone_number } } }
  end
  
  def add_friend
    current_user.friends << User.where(:uri => '/' + params[:uri])[0]
    if current_user.save!
      render :json => {"status" => "success", "data" => "Successful."}
    else
      render :json => {"status" => "failure", "data" => "Error"}
    end
  end

  def remove_friend
    @user = User.where(:uri => ('/' + params[:uri]))[0]
    current_user.friends.delete @user
    if current_user.save!
      render :json => {"status" => "success", "data" => "Successful."}
    else
      render :json => {"status" => "failure", "data" => "Error"}
    end
  end
end
