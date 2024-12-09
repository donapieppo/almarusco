module ActiveStorageBlobKeyOverride
  def key
    "almarusco/#{super}"
  end
end

ActiveSupport.on_load(:active_storage_blob) do
  prepend ActiveStorageBlobKeyOverride
end
