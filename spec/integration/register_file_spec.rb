RSpec.describe Dry::System::Hanami, 'register_file!' do
  context 'repositories file' do
    before do
      class Test::Container < Dry::System::Container
        extend Dry::System::Hanami::Resolver

        configure do |config|
          config.root = SPEC_ROOT.join('fixtures').realpath
        end

        register_file! 'test/repositories/user_repository'
      end

      Test::Container.finalize!
    end

    it { expect(Test::Container['repositories.user']).to be_an_instance_of(UserRepository) }
  end

  context 'entities file' do
    before do
      class Test::Container < Dry::System::Container
        extend Dry::System::Hanami::Resolver

        configure do |config|
          config.root = SPEC_ROOT.join('fixtures').realpath
        end

        register_file! 'test/entities/user'
      end

      Test::Container.finalize!
    end

    it { expect(Test::Container['entities.user']).to be_an_instance_of(User) }
  end

  context 'non hanami specific file' do
    before do
      class Test::Container < Dry::System::Container
        extend Dry::System::Hanami::Resolver

        configure do |config|
          config.root = SPEC_ROOT.join('fixtures').realpath
        end

        register_file! 'test/services/user/create'
      end

      Test::Container.finalize!
    end

    it { expect(Test::Container['services.user.create']).to be_an_instance_of(Services::User::Create) }
  end

  context 'file with custom resolver' do
    before do
      class Test::Container < Dry::System::Container
        extend Dry::System::Hanami::Resolver

        configure do |config|
          config.root = SPEC_ROOT.join('fixtures').realpath
        end

        register_file! 'test/workers/fetch_user', resolver: ->(k) { k }
      end

      Test::Container.finalize!
    end

    it { expect(Test::Container['workers.fetch_user']).to eq(Workers::FetchUser) }
  end

  context 'two diferent files' do
    before do
      class Test::Container < Dry::System::Container
        extend Dry::System::Hanami::Resolver

        configure do |config|
          config.root = SPEC_ROOT.join('fixtures').realpath
        end

        register_file! 'test/services/user/create'
        register_file! 'users/operations/create'
      end

      Test::Container.finalize!
    end

    it { expect(Test::Container['services.user.create']).to be_an_instance_of(Services::User::Create) }
    it { expect(Test::Container['users.operations.create']).to be_an_instance_of(Users::Operations::Create) }
  end
end
