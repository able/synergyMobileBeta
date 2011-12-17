class Mapping 
  include Mongoid::Document

  field :liveType
  field :realID
  field :humanID

  attr_accessible :liveType, :realID, :humanID
end


