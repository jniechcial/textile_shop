CarrierWave.configure do |config|
  case Rails.env
    when 'production'
      config.fog_provider = 'fog/aws'
      config.fog_credentials = {
        provider: 'AWS',
        aws_access_key_id: Rails.application.secrets.AWS_S3_ACCESS_KEY,
        aws_secret_access_key: Rails.application.secrets.AWS_S3_SECRET_KEY,
        region: Rails.application.secrets.AWS_S3_REGION,
      }
      config.fog_directory  = Rails.applcation.secrets.AWS_S3_BUCKET
      config.storage = :fog

    when 'development'
      config.storage = :file

    when 'test'
      config.storage = :file
  end
end
