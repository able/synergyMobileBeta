class Zone 
  include Mongoid::Document

  field :liveLinkId
  field :timestamp
  field :zoneType

  attr_accessible :liveLinkID, :timestamp, :zoneType
end


