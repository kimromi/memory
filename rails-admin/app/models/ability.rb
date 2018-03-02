class Ability
  include CanCan::Ability

  def initialize(employee)
    employee ||= Employee.new

    emplyee.roles.each do |role|
      send("#{role}_ability", employee)
    end
  end

  private

  def member_ability(_)
    can :manage, :all
  end

  def admin_ability(_)
    can :manage, :all
  end
end
