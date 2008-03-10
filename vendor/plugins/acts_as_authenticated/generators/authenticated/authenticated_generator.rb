class AuthenticatedGenerator < Rails::Generator::NamedBase
  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_singular_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    # Take controller name from the next argument.  Default to the pluralized model name.
    @controller_name = args.shift
    @controller_name ||= ActiveRecord::Base.pluralize_table_names ? @name.pluralize : @name

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_singular_name, @controller_plural_name = inflect_names(base_name)

    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions controller_class_path, "#{controller_class_name}Controller", 
                                                #"#{controller_class_name}ControllerTest", 
                                                "#{controller_class_name}Helper"
      m.class_collisions class_path,            "#{class_name}"
                                                #"#{class_name}Test"
      m.class_collisions [], 'AuthenticatedSystem', 'AuthenticatedTestHelper'

      # Controller, helper, views, and test directories.
      m.directory File.join('app/models', class_path)
      m.directory File.join('app/controllers', controller_class_path)
      m.directory File.join('app/helpers', controller_class_path)
      m.directory File.join('app/views', controller_class_path, controller_file_name)
      m.directory File.join('test/functional', controller_class_path)
      m.directory File.join('test/unit', class_path)

      m.template 'model.rb',
                  File.join('app/models',
                            class_path,
                            "#{file_name}.rb")

      m.template 'controller.rb',
                  File.join('app/controllers',
                            controller_class_path,
                            "#{controller_file_name}_controller.rb")

      m.template 'authenticated_system.rb',
                  File.join('lib', 'authenticated_system.rb')

      m.template 'authenticated_test_helper.rb',
                  File.join('lib', 'authenticated_test_helper.rb')

      m.template 'functional_test.rb',
                  File.join('test/functional',
                            controller_class_path,
                            "#{controller_file_name}_controller_test.rb")

      m.template 'helper.rb',
                  File.join('app/helpers',
                            controller_class_path,
                            "#{controller_file_name}_helper.rb")

      m.template 'unit_test.rb',
                  File.join('test/unit',
                            class_path,
                            "#{file_name}_test.rb")

      m.template 'fixtures.yml',
                  File.join('test/fixtures',
                            "#{table_name}.yml")

      # Controller templates
      %w( index login signup ).each do |action|
        m.template "#{action}.rhtml",
                   File.join('app/views', controller_class_path, controller_file_name, "#{action}.rhtml")
      end

      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
        }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
      end
    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} authenticated ModelName [ControllerName]"
    end
end
