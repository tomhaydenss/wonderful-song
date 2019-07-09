module PositionsHelper
  def permissions
    options = []
    Permission::SUBJECTS.each do |subject|
      Permission::ACTIONS.each do |action|
        options << I18n.t(action, scope: 'permissions.actions') + ' ' + I18n.t(subject, scope: 'permissions.subjects')
      end
    end
    options
  end
end