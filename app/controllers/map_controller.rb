class MapController < ActionController::Base
  def coordinates
    data = Hash.new
    @entities = Entity.any_in(:subtype => ["cubicle", "focus-room", "mail-room", "office", "open-area", "phone-room", "conference-room", "kitchen" ])
#.where(:ancestors => "12")
    spaceArray = Array.new
    @entities.each do |entity|
      print entity.name
      coords = entity.coordinates.split(',')
      spaceArray.push({:name => entity.name, :coordinates => { 'x' => coords[0], 'y' => coords[1]}, :dimensions => entity.dimensions, :uri => entity.uri, :subtype => entity.subtype})
    end
    users = Array.new
    @friends = current_user.friends
    @friends.each do |friend|
      state = State.where(:type => 'currentOccupancy').any_in(:value => [friend.uri]).desc(:timestamp)
      if not state.empty?
        space = state[0].entity
        coords = space.coordinates.split(',')
        coords = { 'x' => coords[0], 'y' => coords[1]}
        users << {:name => friend.name, :coordinates => coords, :time => state[0].timestamp }
      end
    end
    data['spaces'] = spaceArray
    data['users'] = users
    render :json => data 
  end
  def friends_coordinates
    data = Hash.new
    users = Hash.new
    @friends = current_user.friends
    @friends.each do |friend|
      state = State.where(:type => 'currentOccupancy').any_in(:value => [friend.uri]).desc(:timestamp)
      if not state.empty?
        space = state[0].entity
        coords = space.coordinates.split(',')
        coords = { 'x' => coords[0], 'y' => coords[1]}
        users[friend.name] =  {:name => friend.name, :coordinates => coords, :time => state[0].timestamp }
      end
    end
    data['users'] = users
    render :json => data 
  end




end
