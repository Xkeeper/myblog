module CoreExtensions
  module String
  
    def slugorize
      Russian::transliterate(self).parameterize
    end

    def slugorize!
      self.replace(self.slugorize)
    end

  end
end

String.send(:include, CoreExtensions::String)
