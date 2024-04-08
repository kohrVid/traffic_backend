# frozen_string_literal: true

# Serialiser for page records. The Page model represents the pages in the
# frontend that have tracking enabled
class PageSerializer
  include ActiveModel::Serialization

  def initialize(page = {})
    @page = page
  end

  def attributes
    {
      id: nil,
      name: nil,
      url: nil
    }
  end

  private

  def id
    @page[:id]
  end

  def name
    @page[:name]
  end

  def url
    @page[:url]
  end
end
