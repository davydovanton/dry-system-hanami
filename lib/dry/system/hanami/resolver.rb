module Dry
  module System
    module Hanami
      module Resolver
        PROJECT_NAME = ::Hanami::Environment.new.project_name

        def register_folder!(folder, resolver: ->(k) { k.new })
          all_files_in_folder(folder).each do |file|
            register_name = file.sub("lib/#{PROJECT_NAME}/", '').gsub('/', '.').gsub(/_repository\z/, '')
            register(register_name, memoize: true) { load! file, resolver: resolver }
          end
        end

        def all_files_in_folder(folder)
          Dir
            .glob("lib/#{folder}/**/*.rb")
            .map! { |file_name| "#{file_name.sub!('.rb', '')}" }
        end

        def load!(path, resolver: ->(k) { k.new })
          load_file!(path)

          unnecessary_part = case path
                             when /repositories/
                               "lib/#{PROJECT_NAME}/repositories"
                             when /entities/
                               "lib/#{PROJECT_NAME}/entities"
                             else
                               "lib/#{PROJECT_NAME}/"
                             end
          right_path = path.sub(unnecessary_part, '')

          resolver.call(Object.const_get(Inflecto.camelize(right_path)))
        end

        def load_file!(path)
          require_relative "#{::Hanami.root}/#{path}"
        end
      end
    end
  end
end
