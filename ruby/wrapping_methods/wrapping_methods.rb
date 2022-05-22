module TimeWrapper
  def self.included(base_class)
    include ClassMethods
    base_class.extend ClassMethods
  end

  module ClassMethods
    def wrap_method(method_name, *args)
      start_time = Time.now
      result = method(method_name).call(*args)
      end_time = Time.now
      puts "#{method_name} took: #{end_time - start_time} seconds"
      result
    end

    def wrap_methods(*method_names)
      method_names.each do |method_name|
        if instance_methods.include?(method_name.to_sym)
          alias_method "original_#{method_name}".to_sym, "#{method_name}".to_sym # save original method
          define_method("wrapped_#{method_name}".to_sym) { |*args| wrap_method("original_#{method_name}", *args) } # create new wrapped method
          alias_method "#{method_name}".to_sym, "wrapped_#{method_name}".to_sym # assign original method to new wrapped method
        else
          self.singleton_class.send(:alias_method, "original_#{method_name}".to_sym, "#{method_name}".to_sym) # save original method
          define_singleton_method("wrapped_#{method_name}".to_sym) { |*args| wrap_method("original_#{method_name}", *args) } # create new wrapped method
          self.singleton_class.send(:alias_method, "#{method_name}".to_sym, "wrapped_#{method_name}".to_sym) # assign original method to new wrapped method
        end
      end
    end

  end
end

module FibUtils
  include TimeWrapper

  class << self
    def fibonacci(index)
      return 0 if index == 0
      return 1 if index < 3
      fibonacci(index-2) + fibonacci(index-1)
    end
  end
end

class App
  include FibUtils
  include TimeWrapper

  def initialize
  end

  def fibonacci_test(index)
    puts "Fib number #{index} is: #{FibUtils.fibonacci(index)}"
  end

  wrap_methods :fibonacci_test
end

app = App.new
app.fibonacci_test(40)