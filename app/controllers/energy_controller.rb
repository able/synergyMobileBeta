class EnergyController < ActionController::Base
  require 'date'

  def index
    if user_signed_in?
      render 'menu' 
    end
  end

  def find_entity_by_uri(uri)
    return Entity.where(:uri => uri)[0] 
  end
  
  def children(uri)
    tokens = uri.split("/")
    ancestors = tokens[1,tokens.length-1]
    children = Entity.all_in(:ancestors => ancestors).to_a
    return children
  end


  def hour_data
    uri = '/' + params[:uri]

    max = DateTime.now.to_f
    min = max - 3600 

    data = [] 
    legend_hash = Array.new 

    ent = find_entity_by_uri(uri) 

    if ent.type == 'thing'
      print 'it is a thing'
      livePulseID = ent.livePulseID
      arr = Energy.where(:livePulseID => livePulseID, :timestamp.lte => max, :timestamp.gte =>min).order_by([:timestamp, :desc]).to_a
      legend_hash[0] = ent.name 
      new_arr = []
      arr.map.with_index do |item, index|
        a = Hash.new
        a['index'] = index
        a['timestamp'] = item['timestamp']
        a['average_power'] = item['average_power']
        new_arr << a 
      end
      data << new_arr
      energy_data = Hash.new
      energy_data['data'] = data
      energy_data['legend'] = legend_hash
      print energy_data
      render :json => energy_data
      return 
    end
  
    children = children(uri)
    children.each.with_index do |child, i|
      if child.subtype != 'sms-gateway'
        livePulseID = child.livePulseID
        arr = Energy.where(:livePulseID => livePulseID, :timestamp.lte => max, :timestamp.gte =>min).order_by([:timestamp, :desc]).to_a
        new_arr = []
        arr.map.with_index do |item, index|
          a = Hash.new
          a['index'] = index
          a['timestamp'] = item['timestamp']
          a['average_power'] = item['average_power']
          new_arr << a
        end
        legend_hash << child.name
        data << new_arr
      end
    end
    energy_data = Hash.new
    energy_data['data'] = data
    energy_data['legend'] = legend_hash
    render :json => energy_data
  end
  def user_hour_data
    uri = '/' + params[:uri]

    max = DateTime.now.to_f
    min = max - 3600 

    legend_hash = Array.new 
    user = User.where(:uri => uri)[0] 
    data = Array.new
    entities = user.entities.where(:type => 'thing').to_a
    entities.each_with_index do |child, i|
      if child.subtype != 'sms-gateway'
        livePulseID = child.livePulseID
        arr = Energy.where(:livePulseID => livePulseID, :timestamp.lte => max, :timestamp.gte =>min).order_by([:timestamp, :asc]).to_a
        new_arr = []
        arr.map.with_index do |item, index|
          a = Hash.new
          a['index'] =  index
          a['timestamp'] = item['timestamp']
          a['average_power'] = item['average_power']
          print index
          new_arr << a
        end
        legend_hash << child.name
        data << new_arr 
      end
    end
    print data
    
    energy_data = Hash.new
    energy_data['data'] = data
    energy_data['legend'] = legend_hash 
    # render json
    render :json => energy_data
  end





  def thing_energy
    print 'menu'
  end
  

  def thing_energy4
    print 'menu'
  end
  
  def energy_last_ten_minutes
    num_readings = params[:num_readings]
    entity_id = params[:id]
    readings = None
    ent = Entity.find(entity_id)
    if ent.type == 'thing'
      arr = ent.energy.order_by([:timestamp, :desc]).limit(10)
      readings = arr 
    else
      # grab all the children
      data = Array.new
      children = Entity.where(:name => name).all_in(:ancestors => ancestors).to_a
      legend_hash = Hash.new
      children.each.with_index do |child, i| 
        arr = child.energy.order_by([:timestamp, :desc]).limit(10).to_a
        arr.map do |item| de
          item['index'] =  i
        end  
        legend_hash[i] = child.uri
        data = data | arr
      end
      readings = Hash.new
      readings['data'] = data 
      readings['legend'] = legend_hash
    end

    # take energy readings of entity in descending order of timestamp 
    # render json
    respond_to do |format|
      format.json {render :json => readings}
    end
  end  
  
  def energy_last_half_hour
    num_readings = params[:num_readings]
    entity_id = params[:id]
    # take energy readings of entity in descending order of timestamp 
    # render json
  end  
  
  def energy_last_hour
    num_readings = params[:num_readings]
    entity_id = params[:id]
    # take energy readings of entity in descending order of timestamp 
    # render json
  end  
  
  def energy_last_five_hours
    num_readings = params[:num_readings]
    entity_id = params[:id]
    # take energy readings of entity in descending order of timestamp 
    # render json
  end  
  

end
