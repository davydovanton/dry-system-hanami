# frozen_string_literal: true

module Dry
  module System
    module Hanami
      module Resolver
        PROJECT_NAME = ::Hanami::Environment.new.project_name
        LIB_FOLDER = "lib/".freeze
        CORE_FOLDER = "#{PROJECT_NAME}/".freeze
        DEFAULT_RESOLVER = ->(k) { k.new }

        def register_folder!(folder, resolver: DEFAULT_RESOLVER)
          all_files_in_folder(folder).each do |file|
            register_name = file.sub(LIB_FOLDER, '').sub(CORE_FOLDER, '').tr('/', '.').sub(/_repository\z/, '')
            register(register_name, memoize: true) { load! file, resolver: resolver }
          end
        end

        def register_file!(file, resolver: DEFAULT_RESOLVER)
          find_file(file) do |f|
            register_name = f.sub(LIB_FOLDER, '').sub(CORE_FOLDER, '').tr('/', '.').sub(/_repository\z/, '')
            register(register_name, memoize: true) { load! f, resolver: resolver }
          end
        end

        private

        def find_file(file)
          Dir.chdir(::Hanami.root) do
            yield *Dir.glob("lib/#{file}.rb").first.sub('.rb', '').to_s
          end
        end

        def all_files_in_folder(folder)
          Dir.chdir(::Hanami.root) do
            Dir.glob("lib/#{folder}/**/*.rb")
               .map! { |file_name| file_name.sub('.rb', '').to_s }
          end
        end

        def load!(path, resolver: DEFAULT_RESOLVER)
          load_file!(path)

          unnecessary_part = case path
                             when /repositories/
                               "#{CORE_FOLDER}repositories/"
                             when /entities/
                               "#{CORE_FOLDER}entities/"
                             else
                               CORE_FOLDER
                             end
          right_path = path.sub(LIB_FOLDER, '').sub(unnecessary_part, '')

          resolver.call(Object.const_get(Inflecto.camelize(right_path)))
        end

        def load_file!(path)
          require_relative "#{::Hanami.root}/#{path}"
        end
      end
    end
  end
end
