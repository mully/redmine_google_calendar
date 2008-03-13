#       iframe_tab_controller.rb
#       
#       Copyright 2008 Jim Mulholland <jim@squeejee.com>
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.

require 'tzinfo'

class GoogleCalendarController < ApplicationController
  layout 'base'
  before_filter :find_project, :authorize
  
  def show
    @iframe_text = IframeText.get_iframe_text(@project)
    
    unless User.current.time_zone.nil?
        time_zone = tzinfo_from_offset(User.current.time_zone.utc_offset)
        
        #If "pvttk" string is not in the iframe, this is a public calendar
        if @iframe_text[/pvttk/].nil?
            #Substitute in the current timezone for public calendar
            @iframe_text.sub!(/ctz=\S*"/, "ctz=#{time_zone.name}\"")
        else
            #Substitute in the current timezone for private calendar
            @iframe_text.sub!(/ctz=\S*&/, "ctz=#{time_zone.name}&")
        end
    end
  end
  

private
  def find_project   
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def tzinfo_from_offset(offset_in_seconds)
    
    #Search For US Timezones First
    us = TZInfo::Country.get('US')
    
    us.zone_info.each do |tz|
        if tz.timezone.current_period.utc_offset.to_i == offset_in_seconds        
            return tz.timezone
        end
    end
    
    TZInfo::Timezone.all.each do |tz2|
        if tz2.current_period.utc_offset.to_i == offset_in_seconds
            return tz2
        end
    end
    return nil
   end
end

