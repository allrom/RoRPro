class FileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :file_name, :file_url

  def file_name
    object.filename.to_s
  end

  def file_url
    # Should not use 'service_url' in serializer, as its a temporary construction.
    # Rails suggests to not call 'Rails.application.routes.url_helpers' directly,
    # as it slows down response

    rails_blob_path(object, only_path: true) if object.attachments
  end
end
