# redMine - project management software
# Copyright (C) 2006-2007  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Google Calendar'

# Redmine ticket emailer plugin
Redmine::Plugin.register :redmine_google_calendar do
  name 'Google Calendar Plugin'
  author 'Jim Mulholland'
  description 'A plugin to allow users to add a new tab with an embedded Google Calendar Iframe.'
  version '0.1.0'
  
  # The data necessary to log into your email server.
  # For this first rev, I am assuming you have an IMAP server
  settings :default => {'iframe_text' => ''}, :partial => 'settings/settings'

  # This plugin adds a project module
  # It can be enabled/disabled at project level (Project settings -> Modules)
  project_module :google_calendar do
    # This permission has to be explicitly given
    # It will be listed on the permissions screen
    permission :view_google_calendar_tab, {:google_calendar => :show}
  end

  # A new item is added to the project menu
  menu :project_menu, 'Calendar', :controller => 'google_calendar', :action => 'show'
end

Rails::Plugin.class_eval do
   def reloadable!
     load_paths.each { |p| Dependencies.load_once_paths.delete(p) }
   end
end

reloadable!
