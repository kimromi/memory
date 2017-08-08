module Admin
  class Engine < ::Rails::Engine
    isolate_namespace Admin

    Gem.loaded_specs['admin'].dependencies.each do |d|
      require d.name
    end
  end
end
