# frozen_string_literal: true

module Dry
  module System
    module Hanami
      module Resolver
        PROJECT_NAME = ::Hanami::Environment.new.project_name
        PROJECT_FOLDER = "lib/#{PROJECT_NAME}/".freeze

        def register_folder!(folder, resolver: ->(k) { k.new })
          all_files_in_folder(folder).each do |file|
            register_name = file.sub(PROJECT_FOLDER, '').tr('/', '.').sub(/_repository\z/, '')
            register(register_name, memoize: true) { load! file, resolver: resolver }
          end
        end

        def all_files_in_folder(folder)
          Dir
            .glob("lib/#{folder}/**/*.rb")
            .map! { |file_name| file_name.sub('.rb', '').to_s }
        end

        def load!(path, resolver: ->(k) { k.new })
          load_file!(path)

          unnecessary_part = case path
                             when /repositories/
                               "#{PROJECT_FOLDER}repositories"
                             when /entities/
                               "#{PROJECT_FOLDER}entities"
                             else
                               PROJECT_FOLDER
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
