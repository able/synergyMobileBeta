class EntitiesController < ApplicationController
  respond_to :html, :json  

    
  
  def create_livePulse
    print 'params'
    print params
    uri = '/' + params[:uri]
    livePulseID = params[:entity]['name']
    entity = Entity.where(:uri => uri)[0]
    entity['livePulseID'] = livePulseID
    entity.save!
    redirect_to '/liveSynergy' + uri

  end

  def new_thing 
    @entity = Entity.new
    @prototypes = Prototype.all.to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new
    
    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end
      
    @subtypes.each do |subtype| 
      entities = Entity.where(:subtype=>subtype, :ownership=>'public', :type =>"space")
      entities = entities | Entity.where(:subtype=>subtype, :ownership=>current_user.uri, :type =>"space")
      arr = Array.new
      entities.each do |entity| 
        ancestors = entity.ancestors
        path = ""
        ancestors.each do |ancestor|
          path = path + "/" + ancestor
        end
        path = path + "/" + entity.name
        arr << path
      end
      if not arr.empty?
        @hash[subtype] = arr
      end
    end
  end

  def new_space 
    @entity = Entity.new
    @prototypes = Prototype.all.to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new
    
    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end
      
    @subtypes.each do |subtype| 
      entities = Entity.where(:subtype=>subtype, :ownership=>'public', :type =>"space")
      entities = entities | Entity.where(:subtype=>subtype, :ownership=>current_user.uri, :type =>"space")
      arr = Array.new
      entities.each do |entity| 
        ancestors = entity.ancestors
        path = ""
        ancestors.each do |ancestor|
          path = path + "/" + ancestor
        end
        path = path + "/" + entity.name
        arr << path
      end
      if not arr.empty?
        @hash[subtype] = arr
      end
    end
  end

  def find_entity_by_uri(uri)
    return Entity.where(:uri => uri)[0] 
  end

 
  def choose_containing_space
    @prototypes = Prototype.all.to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new
    
    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end
      
    @subtypes.each do |subtype| 
      entities = Entity.where(:subtype=>subtype, :ownership=>'public', :type =>"space")
      arr = Array.new
      entities.each do |entity| 
        ancestors = entity.ancestors
        path = ""
        ancestors.each do |ancestor|
          path = path + "/" + ancestor
        end
        path = path + "/" + entity.name
        arr << path
      end
      if not arr.empty?
        @hash[subtype] = arr
      end
    end
  end

  def find_entity_by_uri(uri)
    return Entity.where(:uri => uri)[0] 
  end

  def turnOn
    @host = "http://127.0.0.1"
    @port = "8888"
    @path = "/" + params[:uri] + "/methods/turnOn"
    request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' =>'application/json'})
    request.body = @body
    response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }
    puts "Response #{response.code} #{response.message}: #{response.body}"
    print "Response #{response.code} #{response.message}: #{response.body}"
    status = response.body
    if status[1,4] == 'FAIL'
      redirect_to failure_actuation_path
    end

  end

  def turnOff
    @host = "http://127.0.0.1"
    @port = "8888"
    @path = "/" + params[:uri] + "/methods/turnOff"
    request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' =>'application/json'})
    request.body = @body
    response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }
    puts "Response #{response.code} #{response.message}: #{response.body}"
    print "Response #{response.code} #{response.message}: #{response.body}"
    status = response.body
    if status[1,4] == 'FAIL'
      redirect_to failure_actuation_path
    end

  end

  def view
    uri = params
    @entity = find_entity_by_uri('/' + params[:uri]) 
    print params
    @children = Entity.where(:parent => @entity.name)
 
    @ent_in_coll = false
    if not current_user.entities.where(:uri => @entity.uri).empty?
      @ent_in_coll = true
    end
  end

  def view_added_dialog
    @entity = find_entity_by_uri('/' + params[:uri])
    print current_user.entities 
    current_user.entities.push @entity
  end

  # if private
  def delete_entity
    print 'IN VIEW ADDED DIALOG'
    print 'deleting'
    print params[:uri]
    @entity = find_entity_by_uri('/' + params[:uri]) 
    current_user.entities.delete @entity
    if @entity.ownership == "public"
      @entity.delete
    else
      current_user.entities.delete @entity
    end
    if @entity.type == 'space'
      redirect_to spaces_all_path 
    end
    if @entity.type == 'thing'
      redirect_to things_all_path
    end
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
  
  def public_things
    @prototypes = Prototype.all.where(:ancestors => 'thing').to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new

    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end

    @subtypes.each do |subtype|
      entities = current_user.things.where(:subtype => subtype, :ownership => 'public')
      arr = Array.new
      entities.each do |entity|
        arr << entity.uri
      end

      if not arr.empty?
        @hash[subtype] = arr
      end
    end
  end

  def private_things
    @prototypes = Prototype.all.where(:ancestors => 'thing').to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new

    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end

    @subtypes.each do |subtype|
      entities = current_user.things.where(:subtype => subtype, :ownership => current_user.uri)
      arr = Array.new
      entities.each do |entity|
        arr << entity.uri
      end

      if not arr.empty?
        @hash[subtype] = arr
      end
    end
  end
  
  def list_all_things
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
  def list_all_spaces
    @prototypes = Prototype.all.where(:ancestors => 'space').to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new
    
    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end
      
    @subtypes.each do |subtype| 
      entities = current_user.spaces.where(:subtype => subtype)
      arr = Array.new
      entities.each do |entity| 
        arr << entity.uri
      end
       
      if not arr.empty?
        @hash[subtype] = arr
      end
    end
  end
  def public_spaces
    @prototypes = Prototype.all.where(:ancestors => 'space').to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new
    
    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end
      
    @subtypes.each do |subtype| 
      entities = current_user.spaces.where(:subtype => subtype, :ownership => 'public')
      arr = Array.new
      entities.each do |entity| 
        arr << entity.uri
      end
       
      if not arr.empty?
        @hash[subtype] = arr
      end
    end
  end
  def private_spaces
    @prototypes = Prototype.all.where(:ancestors => 'space').to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new
    
    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end
      
    @subtypes.each do |subtype| 
      entities = current_user.spaces.where(:subtype => subtype, :ownership => current_user.uri)
      arr = Array.new
      entities.each do |entity| 
        arr << entity.uri
      end
       
      if not arr.empty?
        @hash[subtype] = arr
      end
    end
  end

  
  def add_existing_thing
    @prototypes = Prototype.all.to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new
    
    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end
      
    @subtypes.each do |subtype| 
      entities = Entity.where(:subtype=>subtype, :ownership=>'public', :type =>"thing")
      arr = Array.new
      entities.each do |entity| 
        arr << entity.uri
      end
       
      if not arr.empty?
        @hash[subtype] = arr
      end
    end
  end
  
  def add_existing_space
    @prototypes = Prototype.all.to_a.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @subtypes = Array.new
    @hash = Hash.new
    
    @prototypes.each do |prototype|
      @subtypes << prototype.name
    end
      
    @subtypes.each do |subtype| 
      entities = Entity.where(:subtype=>subtype, :ownership=>'public', :type =>"space")
      arr = Array.new
      entities.each do |entity| 
        ancestors = entity.ancestors
        path = ""
        ancestors.each do |ancestor|
          path = path + "/" + ancestor
        end
        path = path + "/" + entity.name
        arr << path
      end
      if not arr.empty?
        @hash[subtype] = arr
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @things }
    end
  end
  
  def add_new_thing
    @entity = Entity.new
  end

  def add_new_space
    @entity = Entity.new
  end

  def add_new_trigger
    @trigger = Trigger.new
    @entities = current_user.entities
    @entities_arr = Array.new
    @entities.each do |entity|
      print entity.uri
      @entities_arr << [entity.uri, entity.uri]
      # x += 1
    end
    
    @entities_arr.insert(0, ["Select from My Collection","0"])
    
  end
  
  def create_new_trigger
    @trigger = Trigger.new(params)
    params['owner'] = current_user.uri
    num_triggers = current_user.triggers.size + 1
    if params['name'] == ""
      params['name'] = 'trigger #' + num_triggers.to_s
    end
    if current_user.triggers.create!(params) 
      render 'triggers/view_added_dialog' 
    else
      render entities_add_new_trigger_path
    end 
  end 
          
  def new_thing_created
    @entity = Entity.new
    print params
    name = params['name'].gsub(/\s+/, "-").gsub(/[^\w-]/, "-").downcase
    livePulseID = params['livePulseID']
    type = params['type']
    uri = params['uri']
  
    @parent = Entity.where(:uri => uri)[0]
    coordinates = @parent.coordinates

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
    
    @entity.write_attributes(
      name: name,
      livePulseID: livePulseID,
      type: type,
      uri: uri + '/' + name,
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
       
    if @entity.save
      print 'SAVING'
      current_user.entities << @entity 
      current_user.save!
      # render added_path 
      render home_menu_path 
    else
      # show errorss
      render entities_add_new_thing_path
    end 
  end
  
  def create_existing_thing
    current_user.things << params[:id]
    current_user.save!
    render :nothing => true
  end
end
