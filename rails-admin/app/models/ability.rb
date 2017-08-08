class Ability
  include CanCan::Ability

  def initialize(employee)
    if employee.admin?
      can :manage, :all
    elsif employee.member?
      can :member, :all
    end
  end
end
