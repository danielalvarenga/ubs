# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base

  include Uuidable

  self.abstract_class = true

end
