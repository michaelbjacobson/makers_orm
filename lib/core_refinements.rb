module MakersORM
  module CoreRefinements
    refine String do
      def snake_case
        gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_')
          .downcase
      end

      def plural
        "#{self}s"
      end
    end
  end
end
