module MakersORM
  module Model
    include DBTypes
    using CoreRefinements

    module ClassMethods
      def create(attributes = {})
        id = Database.insert_row(table_name, attributes)
        attributes['id'] = id
        new(attributes)
      end

      def all(attributes = {})
        resources = Database.select_from(table: table_name, where: attributes)
        resources.map(&method(:new))
      end

      def first(attributes = {})
        all(attributes).min_by(&:id)
      end

      def last(attributes = {})
        all(attributes).max_by(&:id)
      end

      def destroy
        Database.delete_from table: table_name
      end

      def update(attributes)
        all.each { |resource| resource.update(attributes) }
        true
      end

      def get(id)
        resource = Database.select_from(table: table_name, where: { id: id })
        resource.nil? ? nil : new(resource[0])
      end

      def table_name
        name.snake_case.plural
      end

      private

      def property(name, type)
        Database.add_column(table_name, name, type)
      end
    end
  end
end