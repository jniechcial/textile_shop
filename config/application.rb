require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TextileShop
  class Application < Rails::Application

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.i18n.default_locale = :pl

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Override Spree Core routes in order to translate products routes
    initializer "delete_spree_frontend_routes", after: "add_routing_paths" do |app|
      new_spree_frontend_route_path = File.expand_path('../../config/spree_frontend_routes_override.rb', __FILE__)
      routes_paths = app.routes_reloader.paths

      spree_frontend_route_path = routes_paths.select{ |path| path.include?("spree_frontend") }.first

      if spree_frontend_route_path.present?
        spree_frontend_route_path_index = routes_paths.index(spree_frontend_route_path)

        routes_paths.delete_at(spree_frontend_route_path_index)
        routes_paths.insert(spree_frontend_route_path_index, new_spree_frontend_route_path)
      end
    end

    # Override Lines Engine routes in order to translate products routes
    initializer "delete_lines_engine_routes", after: "add_routing_paths" do |app|
      new_lines_engine_route_path = File.expand_path('../../config/lines_engine_routes_override.rb', __FILE__)
      routes_paths = app.routes_reloader.paths
      lines_engine_route_path = routes_paths.select{ |path| path.include?("lines-engine") }.first

      if lines_engine_route_path.present?
        lines_engine_route_path_index = routes_paths.index(lines_engine_route_path)

        routes_paths.delete_at(lines_engine_route_path_index)
        routes_paths.insert(lines_engine_route_path_index, new_lines_engine_route_path)
      end
    end
  end
end
