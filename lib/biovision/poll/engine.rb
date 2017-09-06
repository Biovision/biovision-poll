module Biovision
  module Poll
    class Engine < ::Rails::Engine
      config.assets.precompile << %w(admin.scss)
      config.assets.precompile << %w(biovision/base/icons/*)
      config.assets.precompile << %w(biovision/base/placeholders/*)
    end

    require 'biovision/base'
    require 'carrierwave'
    require 'carrierwave-bombshelter'
    require 'mini_magick'
  end
end
