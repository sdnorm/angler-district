class DisplayProductImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :display do
    process resize_to_limit: [350, 300]
  end

  version :large do
    process resize_to_limit: [600, 600]
  end

  version :medium, :from_version => :large do
    process resize_to_limit: [400, 400]
  end

  version :thumb, :from_version => :medium do
    process resize_to_fit: [100, 100]
  end


  # version :medium, :from_version => :large do
  #   process resize_to_limit: [400, 400]
  # end
  #
  # version :thumb, :from_version => :medium do
  #   process resize_to_fit: [100, 100]
  # end

  # version :square do
  #   process :resize_to_fill => [500, 500]
  # end
end
