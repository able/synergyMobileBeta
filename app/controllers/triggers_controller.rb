class TriggersController < ApplicationController
  require 'json'
  def send_sms_add_trigger_finalize
    title = params['trigger']['title']
    triggering_entity = params['trigger']['triggering_entity']
    triggering_event = params['trigger']['triggering']
    args1 = params['trigger']['user']
    triggered_entity = '/msra/sms-gateway'
    triggered_method = 'send'
    
    sending = {}
    sending['phone_number'] = User.where(:uri => params['trigger']['user'])[0].phone_number
    sending['text'] = params['trigger']['sendtext2']    

    description = '' 
    args2 = sending

    if (triggering_event == 'send')
      sms = {}
      sms['phone_number'] = User.where(:uri => args1)[0].phone_number
      sms['text'] = params['trigger']['sendtext1'] 
      args1 = sms
    end

    if (triggering_event == 'whenNumOccupancyReachesX')
      args1 = params['trigger']['whenNumOccupancyReachesX1'] 
    end

    type1 = 'method'
    if (triggering_event == 'onHumanEnter') || (triggering_event == 'onHumanExit') || (triggering_event == 'whenNumOccupancyReachesX')
        type1 = 'event'
    end

    triggering = {"name" => triggering_event, "type" => type1, "args" => args1} 
    triggered = {"name" => triggered_method, "type" => "method", "args" => args2}
    trig = Trigger.new
    attributes = { 
	"triggering_entity" => triggering_entity, 
	"triggered_entity" => triggered_entity, 
	"name" => title, 
	"triggering" => triggering,
	"triggered" => triggered,
	"description" => description,
        "owner" => current_user.uri
    } 
    current_user.triggers.create!(attributes) 
    render 'triggers/view_added_dialog' 
  end

  def create_new_trigger 
    title = params['trigger']['title']
    triggering_entity = params['trigger']['triggering_entity']
    triggering_event = params['trigger']['triggering']
    args1 = params['trigger']['args1']
    args2 = params['trigger']['args2']
    triggered_entity = params['trigger']['triggered_entity']
    triggered_method = params['trigger']['triggered']
    description = params['trigger']['description'] 
 
    type1 = 'method'
    type2 = 'method'
    if (triggering_event == 'onHumanEnter') || (triggering_event == 'onHumanExit') || (triggering_event == 'whenNumOccupancyReachesX')
	type1 = 'event'
    end

    if (triggered_method == 'onHumanEnter') || (triggered_method == 'onHumanExit')  || (triggered_method == 'whenNumOccupancyReachesX')

	type2 = 'event'
    end
    if (triggering_event == 'send')
      sms = {}
      sms['phone_number'] = User.where(:uri => args1)[0].phone_number
      sms['text'] = params['trigger']['sendtext1'] 
      args1 = sms
    end
    if (triggering_event == 'whenNumOccupancyReachesX')
      args1 = params['trigger']['whenNumOccupancyReachesX1']
    end
    if (triggered_method == 'whenNumOccupancyReachesX')
      args2 = params['trigger']['whenNumOccupancyReachesX2']
    end

    if (triggered_method == 'send')
      sms = {}
      sms['phone_number'] = User.where(:uri => args2)[0].phone_number
      sms['text'] = params['trigger']['sendtext2']
      args2 = sms
    end
    triggering = {"name" => triggering_event, "type" => type1, "args" => args1} 
    triggered = {"name" => triggered_method, "type" => type2, "args" => args2}

    trig = Trigger.new
    attributes = { 
	"triggering_entity" => triggering_entity, 
	"triggered_entity" => triggered_entity, 
	"name" => title, 
	"triggering" => triggering,
	"triggered" => triggered,
	"description" => description,
        "owner" => current_user.uri
    } 
    current_user.triggers.create!(attributes) 
    render 'triggers/view_added_dialog' 
  end


  def send_sms 
    @host = "127.0.0.1"
    @port = "8888"
    @path = "/msra/sms-gateway/methods/send"
    print params[:entity][:user]
    @user = User.where(:uri => params[:entity][:user])[0]
    @body = {}
    @body['phone_number'] = @user.phone_number
    @body['text'] = params[:entity][:text]
    print 'body'
    print @body
    request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' =>'application/json'})
    request.body = @body.to_json
    response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }
    print "Response #{response.code} #{response.message}: #{response.body}"
    status = response.body
    if status[1,4] == 'FAIL'
      redirect_to failure_actuation_path
    end
    redirect_to sms_sent_path
  end

 def turned_on_dialog
    @host = "127.0.0.1"
    @port = "8888"
    @path = "/" + params[:uri] + "/methods/turnOn"
    @body = ""
    request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' =>'application/json'})
    request.body = @body
    response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }
    print "Response #{response.code} #{response.message}: #{response.body}"
    status = response.body
    if status[1,4] == 'FAIL'
      redirect_to failure_actuation_path
    end
  end

  def turned_off_dialog
    @host = "127.0.0.1"
    @port = "8888"
    @path = "/" + params[:uri] + "/methods/turnOff"
    @body = ""
    request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' =>'application/json'})
    request.body = @body
    response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }
    print response
    print "Response #{response.code} #{response.message}: #{response.body}"
    status = response.body
    if status[1,4] == 'FAIL'
      redirect_to failure_actuation_path
    end
  end


   
  def view_added_dialog
  end

  def view_delete_dialog
    @trigger = Trigger.where(:_id => params[:id])
    @trigger.delete
  end

  def find_entity_by_uri(uri)
    return Entity.where(:uri => uri)[0] 
  end

  def onHumanEnter_index
    @entity = find_entity_by_uri('/' + params[:uri]) 
  end
  def whenNumOccupancyReachesX_index
    @entity = find_entity_by_uri('/' + params[:uri]) 
  end

  def whenNumOccupancyReachesX_add_trigger
    @friends = Array.new

    current_user.friends.each do |friend|
      @friends << [friend.uri, friend.uri]
    end

    @entities = Array.new
    current_user.entities.each do |entity|
      @entities << [entity.uri, entity.uri]
    end

    @spaces = Array.new
    current_user.spaces.each do |entity|
      @spaces << [entity.uri, entity.uri]
    end

    @friends.insert(0, ["Choose a user","0"])
    @entities.insert(0, ["Select from my Collection","0"])
    @spaces.insert(0, ["Select from my Collection","0"])
  end

  def onHumanEnter_add_trigger
    @friends = Array.new

    current_user.friends.each do |friend|
      @friends << [friend.uri, friend.uri]
    end

    @entities = Array.new
    current_user.entities.each do |entity|
      @entities << [entity.uri, entity.uri]
    end

    @spaces = Array.new
    current_user.spaces.each do |entity|
      @spaces << [entity.uri, entity.uri]
    end

    @friends.insert(0, ["Choose a user","0"])
    @entities.insert(0, ["Select from my Collection","0"])
    @spaces.insert(0, ["Select from my Collection","0"])
  end

  def whenNumOccupancyReachesX_create_trigger 
    title = params['trigger']['title']
    triggering_entity = params['trigger']['triggering']
    triggering_event = 'whenNumOccupancyReachesX' 
    args1 = params['trigger']['args1']
    args2 = params['trigger']['args2']
    triggered_entity = params['trigger']['triggered_entity']
    triggered_method = params['trigger']['triggered']
    description = params['trigger']['description'] 
 
    type2 = 'method'

    if (triggered_method == 'onHumanEnter') || (triggered_method == 'onHumanExit')  || (triggered_method == 'whenNumOccupancyReachesX')
      type2 = 'event'
    end
    if (triggered_method == 'send')
      sms = {}
      sms['phone_number'] = User.where(:uri => args2)[0].phone_number    
      sms['text'] = params['trigger']['sendtext2'] 
      args2 = sms
    end
    if (triggered_method == 'whenNumOccupancyReachesX')
      args2 = params['trigger']['whenNumOccupancyReachesX2']
    end

        
    triggering = {"name" => triggering_event, "type" => "event", "args" => args1} 
    triggered = {"name" => triggered_method, "type" => type2, "args" => args2}

    trig = Trigger.new
    attributes = { 
	"triggering_entity" => triggering_entity, 
	"triggered_entity" => triggered_entity, 
	"name" => title, 
	"triggering" => triggering,
	"triggered" => triggered,
	"description" => description,
        "owner" => current_user.uri
    } 
    current_user.triggers.create!(attributes) 
    render 'triggers/view_added_dialog' 
  end

  def onHumanEnter_create_trigger 
    title = params['trigger']['title']
    triggering_entity = params['trigger']['triggering']
    triggering_event = 'onHumanEnter' 
    args1 = params['trigger']['args1']
    args2 = params['trigger']['args2']
    triggered_entity = params['trigger']['triggered_entity']
    triggered_method = params['trigger']['triggered']
    description = params['trigger']['description'] 
 
    type2 = 'method'

    if (triggered_method == 'onHumanEnter') || (triggered_method == 'onHumanExit')  || (triggered_method == 'whenNumOccupancyReachesX')

      type2 = 'event'
    end
    if (triggering_event == 'send')
      sms = {}
      sms['phone_number'] = User.where(:uri => args1)[0].phone_number    
      sms['text'] = params['trigger']['sendtext1'] 
      args1 = sms
    end
    if (triggered_method == 'send')
      sms = {}
      sms['phone_number'] = User.where(:uri => args2)[0].phone_number    
      sms['text'] = params['trigger']['sendtext2'] 
      args2 = sms
    end
    if (triggered_method == 'whenNumOccupancyReachesX')
      args2 = params['trigger']['whenNumOccupancyReachesX2']
    end

        
    triggering = {"name" => triggering_event, "type" => "event", "args" => args1} 
    triggered = {"name" => triggered_method, "type" => type2, "args" => args2}

    trig = Trigger.new
    attributes = { 
	"triggering_entity" => triggering_entity, 
	"triggered_entity" => triggered_entity, 
	"name" => title, 
	"triggering" => triggering,
	"triggered" => triggered,
	"description" => description,
        "owner" => current_user.uri
    } 
    current_user.triggers.create!(attributes) 
    render 'triggers/view_added_dialog' 
  end


  def onHumanExit_add_trigger
    @friends = Array.new

    current_user.friends.each do |friend|
      @friends << [friend.uri, friend.uri]
    end

    @entities = Array.new
    current_user.entities.each do |entity|
      @entities << [entity.uri, entity.uri]
    end

    @spaces = Array.new
    current_user.spaces.each do |entity|
      @spaces << [entity.uri, entity.uri]
    end

    @friends.insert(0, ["Choose a user","0"])
    @entities.insert(0, ["Select from my Collection","0"])
    @spaces.insert(0, ["Select from my Collection","0"])

  end

  def onHumanExit_create_trigger 
    title = params['trigger']['title']
    triggering_entity = params['trigger']['triggering']
    triggering_event = 'onHumanExit' 
    args1 = params['trigger']['args1']
    args2 = params['trigger']['args2']

    triggered_entity = params['trigger']['triggered_entity']
    triggered_method = params['trigger']['triggered']
    description = params['trigger']['description'] 
 
    type2 = 'method'

    if (triggered_method == 'onHumanEnter') || (triggered_method == 'onHumanExit') || (triggered_method == 'whenNumOccupancyReachesX')
      type2 = 'event'
    end
    if (triggering_event == 'send')
      sms = {}
      sms['phone_number'] = User.where(:uri => args1)[0].phone_number    
      sms['text'] = params['trigger']['sendtext1'] 
      args1 = sms
    end
    if (triggered_method == 'send')
      sms = {}
      sms['phone_number'] = User.where(:uri => args2)[0].phone_number    
      sms['text'] = params['trigger']['sendtext2'] 
      args2 = sms
    end
    if (triggered_method == 'whenNumOccupancyReachesX')
      args2 = params['trigger']['whenNumOccupancyReachesX2']
    end

        
    triggering = {"name" => triggering_event, "type" => "event", "args" => args1} 
    triggered = {"name" => triggered_method, "type" => type2, "args" => args2}

    trig = Trigger.new
    attributes = { 
	"triggering_entity" => triggering_entity, 
	"triggered_entity" => triggered_entity, 
	"name" => title, 
	"triggering" => triggering,
	"triggered" => triggered,
	"description" => description,
        "owner" => current_user.uri
    } 
    current_user.triggers.create!(attributes) 
    render 'triggers/view_added_dialog' 
  end




  def add_new_trigger
    @friends = Array.new

    current_user.friends.each do |friend|
      @friends << [friend.uri, friend.uri] 
    end

    @entities = Array.new
    current_user.entities.each do |entity|
      print entity.uri
      @entities << [entity.uri, entity.uri]
      # x += 1
    end
   
    @friends.insert(0, ["Choose a user","0"])
    @entities.insert(0, ["Select from my Collection","0"])
 
  end


  def send_sms_index
    @friends = Array.new

    current_user.friends.each do |friend|
      @friends << [friend.uri, friend.uri] 
    end

    @entities = Array.new
    current_user.entities.each do |entity|
      print entity.uri
      @entities << [entity.uri, entity.uri]
      # x += 1
    end
    
    @entities.insert(0, ["Select from My Collection","0"])
    @friends.insert(0, ["Choose a user","0"])
  end 
  def onHumanExit_index
    @entity = find_entity_by_uri('/' + params[:uri]) 
  end

  def currentOccupancy
    @entity = find_entity_by_uri('/' + params[:uri]) 
    @state = State.where(:type => 'currentOccupancy', :entity_id => @entity['_id']).desc(:timestamp)
    if @state.empty?
      @people = []
    else
      @people = @state[0].value
    end
  end



  def send_sms_add_trigger
    @friends = Array.new

    current_user.friends.each do |friend|
      @friends << [friend.uri, friend.uri] 
    end

    @entities = Array.new
    current_user.entities.each do |entity|
      print entity.uri
      @entities << [entity.uri, entity.uri]
      # x += 1
    end

    @friends.insert(0, ["Choose a user","0"])
    @entities.insert(0, ["Select from my Collection","0"])

  end
  
  # GET /triggers
  # GET /triggers.xml
  def index
    @triggers = current_user.triggers
  end

  # GET /triggers/1
  # GET /triggers/1.xml
  def show
    print params
    @trigger = Trigger.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trigger }
    end
  end

  # GET /triggers/new
  # GET /triggers/new.xml
  def new
    @trigger = Trigger.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trigger }
    end
  end

  # GET /triggers/1/edit
  def edit
    @trigger = Trigger.find(params[:id])
    @entities = current_user.things + current_user.spaces
    @entities_arr = Array.new

    @entities.each do |entity|
      print entity
      @entities_arr << [entity, entity]
    end
    @id = @trigger['_id'].to_s

    @triggering = @trigger['triggering']['name']
    @triggered = @trigger['triggered']['name']
  end

  # POST /triggers
  # POST /triggers.xml
  def create
    @trigger = Trigger.new(params[:trigger])

    respond_to do |format|
      if @trigger.save
        @trigger.add_user! current_user
        format.html { redirect_to(@trigger, :notice => 'Trigger was successfully created.') }
        format.xml  { render :xml => @trigger, :status => :created, :location => @trigger }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /triggers/1
  # PUT /triggers/1.xml
  def update
    @trigger = Trigger.find(params[:id])

    respond_to do |format|
      if @trigger.update_attributes(params[:trigger])
        format.html { redirect_to(@trigger, :notice => 'Trigger was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /triggers/1
  # DELETE /triggers/1.xml
  def destroy
    @trigger = Trigger.find(params[:id])
    @trigger.destroy

    respond_to do |format|
      format.html { redirect_to(triggers_url) }
      format.xml  { head :ok }
    end
  end
end

