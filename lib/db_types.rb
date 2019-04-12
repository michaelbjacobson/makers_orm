module MakersORM
  module DBTypes
    class Boolean; end
    class ArrayOfStrings; end
    class ArrayOfIntegers; end

    MAP = {
        String => 'text',
        Integer => 'int',
        Float => 'float',
        Boolean => 'boolean',
        Time => 'timestamp',
        ArrayOfStrings => 'text[]',
        ArrayOfIntegers => 'int[]'
    }.freeze
  end
end