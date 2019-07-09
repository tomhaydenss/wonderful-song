module PositionsHelper
  def permissions
    options = []
    Permission::SUBJECTS.each do |subject|
      Permission::ACTIONS.each do |action|
        options << Permission.new(action: action, subject: subject)
      end
    end
    options
  end
end