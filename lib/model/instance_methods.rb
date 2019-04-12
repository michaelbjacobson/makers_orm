module MakersORM
  module Model
    include DBTypes
    using CoreRefinements

    module InstanceMethods
      def initialize(attributes)
        set_instance_vars(attributes)
        create_attr_readers
      end

      def destroy
        Database.delete_from(table: table_name, where: { id: id })
      end

      def update(attributes)
        Database.update(table: table_name, attributes: attributes, where: { id: id })
        set_instance_vars(attributes)
        true
      end

      def table_name
        self.class.table_name
      end

      private

      def set_instance_vars(attributes)
        attributes.each { |name, val| instance_variable_set("@#{name}", val) }
      end

      def create_attr_readers
        instance_variables.each { |var| self.class.send(:attr_reader, var.to_s[1..-1].to_sym) }
      end
    end
  end
end