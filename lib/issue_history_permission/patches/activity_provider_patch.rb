module IssueHistoryPermission
  module Patches
    module ActivityProviderPatch
      def self.included(base)
        base.include(ModuleMethods)

        base.module_eval do
          alias_method :find_events_without_view_ish_perm, :find_events
          alias_method :find_events, :find_events_with_view_ish_perm
        end
      end

      module ModuleMethods
        def find_events_with_view_ish_perm(event_type, user, from, to, options)
          if event_type == "issues"
            p_options = self.activity_provider_options["issues"]

            if !@__ish_default_activity_scope
              @__ish_default_activity_scope = p_options[:scope]
            end

            p_options[:scope] = @__ish_default_activity_scope

            forbidden_roles = Role.select {|role| !role.has_permission?(:view_issue_history)}.map(&:id)

            ids = User.current.members.select do |member| 
              all_roles_ids = member.member_roles.pluck(:role_id)
              (all_roles_ids - forbidden_roles).empty?
            end.map(&:project_id)

            if ids.any?
              p_options[:scope] = p_options[:scope]
                .where("project_id not in (?)", ids)
            end
          end

          find_events_without_view_ish_perm(event_type, user, from, to, options)
        end

        def excluded_projects_ids
          forbidden_roles = Role.select {|role| !role.has_permission?(:view_issue_history)}.map(&:id)

          User.current.members.select do |member| 
            all_roles_ids = member.member_roles.pluck(:role_id)
            (all_roles_ids - forbidden_roles).empty?
          end.map(&:project_id)
        end
      end
    end
  end
end

base = Redmine::Acts::ActivityProvider::InstanceMethods::ClassMethods
patch = IssueHistoryPermission::Patches::ActivityProviderPatch
base.send(:include, patch) unless base.included_modules.include?(patch)
