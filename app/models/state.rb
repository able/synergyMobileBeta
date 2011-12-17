class State 
  include Mongoid::Document

  field :type
  field :timestamp
  field :value
  belongs_to :entity, :class_name => 'Entity'

  attr_accessible :type, :timestamp, :value, :entity
end


