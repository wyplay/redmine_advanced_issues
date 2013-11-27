# Redmine advanced issues - Plugin improve time entry
# Copyright (C) 2011  Tieu-Philippe Khim
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

require 'redmine_advanced_issues/time_management'

module Hooks

  class ControllerIssuesEditBeforeSaveHook < Redmine::Hook::ViewListener

    def controller_issues_edit_before_save(context={})
	
	  if context[:params].present? && context[:params][:remaining_hours].present?
      	
        value = context[:params][:remaining_hours]
        time_unit = ""
        
        #if value.to_s =~ /^([0-9]+)\s*[a-z]{1}$/
        if (value.to_s.count "/^[a-z]/").to_i > 0
			time_unit = RedmineAdvancedIssues::TimeManagement.getUnitTimeFromChar value.to_s[-1, 1]
        else
          time_unit = Setting.plugin_redmine_advanced_issues['default_unit']
        end #if

        if !time_unit.empty?
            context[:params][:remaining_hours] = RedmineAdvancedIssues::TimeManagement.calculateHours value.to_f, time_unit
        end #if
        
      end #if

      if context[:params].present? && context[:params][:issue].present? && context[:params][:issue][:estimated_time].present?
      	
        value = context[:params][:issue][:estimated_time]
        time_unit = ""
        
        #if value.to_s =~ /^([0-9]+)\s*[a-z]{1}$/
        if (value.to_s.count "/^[a-z]/").to_i > 0
			time_unit = RedmineAdvancedIssues::TimeManagement.getUnitTimeFromChar value.to_s[-1, 1]
        else
          time_unit = Setting.plugin_redmine_advanced_issues['default_unit']
        end #if

        if !time_unit.empty?
            context[:issue][:estimated_time] = RedmineAdvancedIssues::TimeManagement.calculateHours value.to_f, time_unit
            context[:issue][:estimated_hours] = RedmineAdvancedIssues::TimeManagement.calculateHours value.to_f, time_unit
        end #if
        
      end #if
      
      if context[:params].present? && context[:params][:time_entry_hours].present?
        value = context[:params][:time_entry_hours]
        time_unit = ""

        #if value.to_s =~ /^([0-9]+)\s*[a-z]{1}$/
      	if (value.to_s.count "/^[a-z]/").to_i > 0
          time_unit = RedmineAdvancedIssues::TimeManagement.getUnitTimeFromChar value.to_s[-1, 1]
        else
          time_unit = 'days' # Setting.plugin_redmine_advanced_issues['default_unit']
        end #if

        if !time_unit.empty?
            context[:params][:time_entry_hours] = RedmineAdvancedIssues::TimeManagement.calculateHours value.to_f, time_unit
            context[:params][:time_entry_hours] = context[:params][:time_entry_hours].to_s
        end #if

      end #if
      
      if context[:time_entry].present? && context[:time_entry][:hours].present?
        value = context[:time_entry][:hours]
        
        if context[:params].present? && context[:params][:time_entry][:hours].present?
        	value = context[:params][:time_entry][:hours]
        end 
        
        time_unit = ""

        #if value.to_s =~ /^([0-9]+)\s*[a-z]{1}$/
      	if (value.to_s.count "/^[a-z]/").to_i > 0
          time_unit = RedmineAdvancedIssues::TimeManagement.getUnitTimeFromChar value.to_s[-1, 1]
        else
          time_unit = Setting.plugin_redmine_advanced_issues['default_unit']
        end #if

        if !time_unit.empty?
            context[:time_entry][:hours] = RedmineAdvancedIssues::TimeManagement.calculateHours value.to_f, time_unit
            context[:params][:time_entry][:hours] = RedmineAdvancedIssues::TimeManagement.calculateHours value.to_f, time_unit
            
            if context[:issue].time_entries.present? && context[:issue].time_entries.count > 0
            	context[:issue].time_entries[ context[:issue].time_entries.count-1 ][:hours] = RedmineAdvancedIssues::TimeManagement.calculateHours value.to_f, time_unit
            	context[:issue].time_entries[ context[:issue].time_entries.count-1 ].save
            end
            
        end #if

      end #if
      
    
    end #controller_issues_edit_before_save

    alias_method :controller_issues_new_before_save, :controller_issues_edit_before_save

  end #class

end #module

