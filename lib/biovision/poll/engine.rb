module Biovision
  module Poll
    require 'biovision/base'
    require 'carrierwave'
    require 'carrierwave-bombshelter'
    require 'mini_magick'

    class Engine < ::Rails::Engine
      config.assets.precompile << %w(admin.scss)
      config.assets.precompile << %w(biovision/base/**/*)

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_bot, :dir => 'spec/factories'
      end
    end
  end
end
