# frozen_string_literal: true

# The ApplicationRecord class inherited by other models in this repository
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
