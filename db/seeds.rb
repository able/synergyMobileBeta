# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
=begin
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create!( 
    :name => 'Steve Ballmer', 
    :email => 'ceo@microsoft.com',  
    :password => 'please', 
    :password_confirmation => 'please',
    :parent => 'mass',
    :liveLinkID => '0xB2C8AD64036DEB81',
    :phone_number => '11111111111',
    :username => 'steveballmer',
    :uri => User.all_groups[0] + '/' + 'steveballmer',
    :group => User.all_groups[0])

e1 = Entity.where(:name => 'msra-light-1234')[0]
e2 = Entity.where(:name => 'ballmer-hp-desktop-2345')[0]
e3 = Entity.where(:name => 'ballmer-macbook-pro-3456')[0]
e4 = Entity.where(:name => 'msra-phone-6234')[0]
e5 = Entity.where(:name => 'coffee-machine-1423')[0]
e6 = Entity.where(:name => 'msra-refrigerator-4352')[0]
e7 = Entity.where(:name => 'msra-projector-6234')[0]
e8 = Entity.where(:name => '12310')[0]

user.entities << e1
user.entities << e2
user.entities << e3
user.entities << e4
user.entities << e5
user.entities << e6
user.entities << e7
user.entities << e8
user.save!
=end
liveLinkIDs = Array['B2C8AD64036DE275','B2C8AD64036DB8D6','B2C8AD64036DD9AA','B2C8AD64036DC873','B2C8AD64036DE96C','B2C8AD64036DD1DF','B2C8AD64036DBA2C','B2C8AD64036DDB7E','B2C8AD64036DDE8A','B2C8AD64036DC478','B2C8AD64036DEB81','B2C8AD64036D8B9C','B2C8AD64036DC4BA' ]

livePulseIDs = Array['B2C8AD64036E95EB','B2C8AD64036DE06A','B2C8AD64036E94FD','B2C8AD64036DE5D9','B2C8AD64036DB3B8']

liveLinkIDs.each do |liveLinkID|
  Mapping.create!(
    :liveType => 'liveLink', :realID => liveLinkID, :humanID => liveLinkID[liveLinkID.length-4, liveLinkID.length]
  )
end
livePulseIDs.each do |livePulseID|
  Mapping.create!(
    :liveType => 'livePulse', 
    :realID => livePulseID,
    :humanID => livePulseID[livePulseID.length-4, livePulseID.length]
  )
end


=begin
user = User.create!( 
    :name => 'Second User', 
    :email => 'user2@test.com',  
    :password => 'please', 
    :password_confirmation => 'please',
    :parent => 'websm',
    :liveLinkID => '2',
    :phone_number => '21111111111',
    :username => 'first',
    :username => 'second',
    :uri => User.all_groups[1] + '/' + 'second',
    :group => User.all_groups[1])

user = User.create!(
    :name => 'Third User', 
    :email => 'user3@test.com',  
    :password => 'please', 
    :password_confirmation => 'please',
    :parent => 'university',
    :liveLinkID => '3',
    :phone_number => '31111111111',
    :username => 'first',
    :username => 'third',
    :uri => User.all_groups[2] + '/' + 'third',
    :group => User.all_groups[2])

user = User.create!(
    :name => 'Fourth User', 
    :email => 'user4@test.com',  
    :password => 'please', 
    :password_confirmation => 'please',
    :parent => 'graphics',
    :liveLinkID => '4',
    :phone_number => '41111111111',
    :username => 'first',
    :username => 'fourth',
    :uri => User.all_groups[3] + '/' + 'fourth',
    :group => User.all_groups[3])

user = User.create!(
    :name => 'Fifth User', 
    :email => 'user5@test.com',  
    :password => 'please', 
    :password_confirmation => 'please',
    :parent => 'media',
    :liveLinkID => '5',
    :phone_number => '51111111111',
    :username => 'first',
    :username => 'five',
    :uri => User.all_groups[4] + '/' + 'five',
    :group => User.all_groups[4])

user = User.create!(
    :name => 'Sixth User', 
    :email => 'user6@test.com',  
    :password => 'please', 
    :password_confirmation => 'please',
    :parent => 'innovative',
    :liveLinkID => '6',
    :phone_number => '61111111111',
    :username => 'first',
    :username => 'six',
    :uri => User.all_groups[5] + '/' + 'six',
    :group => User.all_groups[5])

puts 'created six test users'
=end
