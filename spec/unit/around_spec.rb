require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Around advices" do
  it "should work" do
    klass = create_test_class do
      def do_this &proxy
        value << "before"
        result = proxy.call
        value << "after"
        result
      end
    end

    aspector(klass) do
      around :test, :do_this
    end

    obj = klass.new
    obj.test
    obj.value.should == %w"before test after"
  end

  it "logic in block" do
    klass = create_test_class

    aspector(klass) do
      around :test do |&proxy|
        value << "before"
        result = proxy.call
        value << "after"
        result
      end
    end

    obj = klass.new
    obj.test
    obj.value.should == %w"before test after"
  end

  it "method_name_arg" do
    klass = create_test_class do
      def do_this method, &proxy
        value << "before(#{method})"
        result = proxy.call
        value << "after(#{method})"
        result
      end
    end

    aspector(klass) do
      around :test, :do_this, :method_name_arg => true
    end

    obj = klass.new
    obj.test
    obj.value.should == %w"before(test) test after(test)"
  end
end

