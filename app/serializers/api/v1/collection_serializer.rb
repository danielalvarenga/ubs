# frozen_string_literal: true

class Api::V1::CollectionSerializer < Api::V1::ApiSerializer

  attributes :current_page, :per_page, :total_entries, :total_pages
  has_many :entries

  delegate :current_page, to: :object

  delegate :per_page, to: :object

  delegate :total_entries, to: :object

  delegate :total_pages, to: :object

  def entries
    ActiveModelSerializers::SerializableResource.new(
      object, each_serializer: instance_options[:each_serializer]
    ).serializable_hash.first.last
  end

end
