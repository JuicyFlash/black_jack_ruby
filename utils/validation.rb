module Validation

  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods

    def validation_checks=(val)
      @@validation_checks = val
    end

    def validation_checks
      @@validation_checks ||= []
    end

    def validate(attr_name, format, options = nil)

      # Хэш формат_проверки -> метод_проверки
      validation ||= {
        format: method(:validate_format),
        presence: method(:validate_presence),
        type: method(:validate_type)
      }

      # Формируем хэш проверки
      hash = { obj_class: self,
               method: validation[format],
               attribute: attr_name,
               param: options }

      # Записываем хэш с проверкой в инстанс переменную класса []
      if validation_checks
        validation_checks.push(hash)
      else
        validation_checks = [hash]
      end
    end

    private

    # Методы проверки
    def validate_presence(obj_class, attribute, value, param)
      raise "Класс #{obj_class} параметр #{attribute} nil или пустая строка" unless value.to_s.length.positive?
    end

    def validate_format(obj_class, attribute, value, format)
      raise "Класс #{obj_class} формат #{attribute} не соответствует" unless format.match?(value)
    end

    def validate_type(obj_class, attribute, value, type)
      raise "Класс #{obj_class} параметр #{attribute} не соответствует типу #{type}, указан тип - #{value.class}" unless value.is_a? type
    end
  end

  module InstanceMethods
    def validate!
      # Получаем список валидирущих методов\параметров класса
      validations = self.class.validation_checks.select { |obj| self.kind_of?(obj[:obj_class]) }
      validations ||= []
      validations.each do |check|

        # Проверяющий метод
        method = check[:method]
        # Название атрибута
        attribute = check[:attribute]
        # Получаем значение атрибута объекта
        attribute_value = instance_variable_get("@#{check[:attribute]}")
        # Доп параметры
        param = check[:param]
        obj_class = self.class
        # Вызов проверяющего метода
        method.call obj_class, attribute, attribute_value, param
      rescue RuntimeError => e
        raise e
      end
    end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end
  end
end
