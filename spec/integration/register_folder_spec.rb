RSpec.describe Dry::System::Hanami, 'register_folder!' do
  context 'repositories folder' do
    before do
      class Test::Container < Dry::System::Container
        extend Dry::System::Hanami::Resolver

        configure do |config|
          config.root = SPEC_ROOT.join('fixtures').realpath
        end

        register_folder! 'test/repositories'
      end

      Test::Container.finalize!
    end

    it { expect(Test::Container['repositories.user']).to be_an_instance_of(UserRepository) }
  end

  context 'entities folder' do
    before do
      class Test::Container < Dry::System::Container
        extend Dry::System::Hanami::Resolver

        configure do |config|
          config.root = SPEC_ROOT.join('fixtures').realpath
        end

        register_folder! 'test/entities'
      end

      Test::Container.finalize!
    end

    it { expect(Test::Container['entities.user']).to be_an_instance_of(User) }
  end

  context 'non hanami specific folder' do
    before do
      class Test::Container < Dry::System::Container
        extend Dry::System::Hanami::Resolver

        configure do |config|
          config.root = SPEC_ROOT.join('fixtures').realpath
        end

        register_folder! 'test/services'
      end

      Test::Container.finalize!
    end

    it { expect(Test::Container['services.user.create']).to be_an_instance_of(Services::User::Create) }
  end

  context 'folder with custom resolver' do
    before do
      class Test::Container < Dry::System::Container
        extend Dry::System::Hanami::Resolver

        configure do |config|
          config.root = SPEC_ROOT.join('fixtures').realpath
        end

        register_folder! 'test/workers', resolver: ->(k) { k }
      end

      Test::Container.finalize!
    end

    it { expect(Test::Container['workers.fetch_user']).to eq(Workers::FetchUser) }
  end

  context 'two diferent folders' do
    before do
      class Test::Container < Dry::System::Container
        extend Dry::System::Hanami::Resolver

        configure do |config|
          config.root = SPEC_ROOT.join('fixtures').realpath
        end

        register_folder! 'test/services'
        register_folder! 'users/operations'
      end

      Test::Container.finalize!
    end

    it { expect(Test::Container['services.user.create']).to be_an_instance_of(Services::User::Create) }
    it { expect(Test::Container['users.operations.create']).to be_an_instance_of(Users::Operations::Create) }
  end
end
