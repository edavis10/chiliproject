#-- encoding: UTF-8
#-- copyright
# ChiliProject is a project management system.
#
# Copyright (C) 2010-2011 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

namespace :users do
  desc <<-DESC
Delete non-activated users who haven't logged in.

  days=14        how old the user account must be. Prevents deleting
                 accounts that were recently registered.
DESC
  task :delete_non_activated => :environment do
    days = ENV['days']
    days = 14 unless days.present?

    users = User.all(:conditions =>
                     [
                      "#{User.table_name}.status = #{User::STATUS_REGISTERED} AND " +
                      "#{User.table_name}.last_login_on IS NULL AND " +
                      "#{User.table_name}.created_on = #{User.table_name}.updated_on AND " +
                      "#{User.table_name}.created_on < (?)",
                      days.to_i.days.ago
                     ])

    users.each do |user|
      user.destroy
    end
    
  end
end
