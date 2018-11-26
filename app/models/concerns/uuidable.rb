# frozen_string_literal: true

module Uuidable
  include ActiveSupport::Concern

  def self.included(base)
    base.primary_key = :id
    base.before_create :assign_uuid
  end

  private

  def assign_uuid
    return if id.present?

    prefix = self.class.name.split('::').last[0..2]
    loop do
      self.id = "#{prefix}#{UUIDTools::UUID.timestamp_create}".upcase
      break unless self.class.exists?(id: id)
    end
  end
end
