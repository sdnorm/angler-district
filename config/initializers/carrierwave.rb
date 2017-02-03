CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAIL3OQ6HITY5F2UXQ',#ENV['S3_KEY'],
      :aws_secret_access_key  => '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',#ENV['S3_SECRET']
      #:region                 => ENV['S3_REGION'] # Change this for different AWS region. Default is 'us-east-1'
  }
  config.fog_directory  = 'angler-district-development'#ENV['S3_BUCKET']
end
