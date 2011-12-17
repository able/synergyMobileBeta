class FriendsController < ApplicationController
  def allfriends
    @friends = current_user.friends.to_a
    render :json => @friends

  end
  def view
    @friend = User.where(:uri => '/' + params[:uri])[0]
  end
  def view_all_friends
    @groups = User.all_groups 
    @hash = Hash.new
    @groups.each do |group| 
      users = current_user.friends.where(:group=>group)
      arr = Array.new
      users.each do |user| 
        if not user.eql? current_user
          name_str = user.name + ' [' + user.username + ']'
          print name_str
	  print user['uri']
          arr << {:id => user['_id'].to_s, :name => name_str, :uri => user.uri}
        end
      end
      if not arr.empty?
        @hash[group] = arr
      end
    end
  end

  def view_delete_dialog
    @user = User.where(:uri => ('/' + params[:uri]))[0]
    print 'yo!!!!'
    print @user.uri
    current_user.friends.delete @user
    current_user.save!
  end

  
  def add_existing_friend
    @groups = User.all_groups 
    @hash = Hash.new
      
    @groups.each do |group| 
      users = User.where(:group=>group)
      arr = Array.new
      users.each do |user| 
        if not user.eql? current_user
          name_str = user.name + ' [' + user.username + ']'
          arr << {:id => user['_id'].to_s, :name => name_str, :uri => user['uri']}
        end
      end
      if not arr.empty?
        @hash[group] = arr
      end
    end
  end
  
  def view_added_dialog 
    current_user.friends << User.where(:uri => '/' + params[:uri])[0]
    current_user.save!
  end 
 
end
