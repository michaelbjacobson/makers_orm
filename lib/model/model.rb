require 'pg'

module MakersORM
  module Model
    include DBTypes
    using CoreRefinements

    def self.create_table_for_model(model)
      table_name = model.name.snake_case.plural
      Database.create_table(table_name)
    end

    def self.included(model_class)
      create_table_for_model(model_class)
      model_class.include(InstanceMethods)
      model_class.extend(ClassMethods)
    end
  end
end
