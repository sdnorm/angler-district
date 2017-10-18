CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['aws_secret_access_key'],#ENV['S3_KEY_ENV'],
      :aws_secret_access_key  => ENV['aws_access_key_id']#ENV['S3_SECRET_ENV']
      #:region                 => ENV['S3_REGION'] # Change this for different AWS region. Default is 'us-east-1'
  }
  config.fog_directory  = ENV['S3_BUCKET']
end
