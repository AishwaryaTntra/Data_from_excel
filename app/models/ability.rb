# frozen_string_literal: true

# app > models > ability
class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :new, :all
      can :create, :all
      can [:read, :edit, :update, :destroy, :new_city_customer_message, :city_customers_message], City do |city|
        city.user_id == user.id
      end
      can [:read, :edit, :update, :destroy], Location do |location|
        location.user_id == user.id
      end
      can [:read, :edit, :update, :destroy], Message do |message|
        message.location.user_id == user.id
      end
      can [:read, :edit, :update, :destroy], Customer do |customer|
        customer.user_id == user.id
      end
    end
  end
end
