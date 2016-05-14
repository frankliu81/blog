class Ability
  include CanCan::Ability

  def initialize(user)
    # we instantiate the user to User.new to avoid having user be nil if the user
    user ||= User.new

    can :manage, :all if user.admin?

    alias_action :create, :read, :udpate, :destroy, :to => :crud

    can :crud, Post do |the_post|
      # only the post owner can crud
      # user.persisted? ensure the user is in the database
      the_post.user == user && user.persisted?
    end

    can :crud, Comment do |comment|
      # allow the post owner and the comment owner to crud
      # byebug
      (comment.post.user == user || comment.user == user) && user.persisted?
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
