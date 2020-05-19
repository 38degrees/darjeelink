# frozen_string_literal: true

module Darjeelink
  class Engine < ::Rails::Engine
    isolate_namespace Darjeelink

    initializer :append_migrations do |app|
      unless app.root.to_s.match? root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'darjeelink.assets.precompile' do |app|
      app.config.assets.precompile += %w[darjeelink/tracking_link_generator.js]
    end
  end
end
