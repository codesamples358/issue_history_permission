class CreateAllowAllExistingRolesToViewIssueHistories < ActiveRecord::Migration[5.2]
  def up
    Role.all.each do |role|
      role.add_permission!(:view_issue_history)
    end
  end
end
