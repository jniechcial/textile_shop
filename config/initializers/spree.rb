Spree.config do |config|
  if Rails.env.production?
    attachment_config = {
      s3_credentials: {
        access_key_id: Rails.application.secrets.AWS_S3_ACCESS_KEY,
        secret_access_key: Rails.application.secrets.AWS_S3_SECRET_KEY,
        bucket: Rails.application.secrets.AWS_S3_BUCKET,
      },

      storage:        :s3,
      s3_region:      Rails.application.secrets.AWS_S3_REGION,
      s3_headers:     { "Cache-Control" => "max-age=31557600" },
      s3_protocol:    "https",
      bucket:         Rails.application.secrets.AWS_S3_BUCKET,
      url:            ":s3_domain_url",

      styles: {
          mini:     "48x48>",
          small:    "100x100>",
          product:  "240x240>",
          large:    "600x600>"
      },

      path:           "/:class/:id/:style/:basename.:extension",
      default_url:    "/:class/:id/:style/:basename.:extension",
      default_style:  "product"
    }

    attachment_config.each do |key, value|
      Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
    end
  end
end

Spree.user_class = "Spree::User"
