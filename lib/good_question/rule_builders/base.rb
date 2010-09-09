require "pinker"
require "pinker/addons/in_list"
require "pinker/addons/in_range"
require "pinker/addons/type_is"

module GoodQuestion
  class BaseRuleBuilder < Pinker::RuleBuilder
    include Pinker::RuleBuilderAddons::InList
    include Pinker::RuleBuilderAddons::InRange
    include Pinker::RuleBuilderAddons::TypeIs
  end
end
  
