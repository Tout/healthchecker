require 'rails'

module Healthchecker
  class Engine < ::Rails::Engine
    isolate_namespace Healthchecker
  end
end
