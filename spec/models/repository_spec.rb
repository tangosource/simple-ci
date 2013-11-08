require 'spec_helper'

describe Repository do
  context 'validations' do
    before :each do
      Repository.skip_callback(:create, :before, :subscribe_hooks)
      Repository.skip_callback(:destroy, :before, :unsubscribe_hooks)
    end
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:url) }
  end

  context 'methods' do
    let(:user){ Fabricate :user}
    let(:repository){
      Repository.create(
        name: 'simple-ci',
        url: 'www.sample.com',
        user_id: user.id)
    }

    it 'hooks_url returns an url of github API' do
     expect(repository.send(:hooks_url)).to eq(
       "/repos/#{user.nickname}/#{repository.name}/hooks"
     )
    end

    it 'subscribe_hooks add the hook_id to the repository before create' do
      hook_id = '123456'
      repository.stub(:subscribe_hooks).and_return(repository.hook_id = hook_id)
      repository.send(:subscribe_hooks)
      expect(repository.hook_id).to eq(hook_id)
    end

    it 'subscribe_hooks returns false if the response does not includes the hook_id' do
      expect(repository.send(:subscribe_hooks)).to be_false
      expect(repository.hook_id).to eq(nil)
    end

    it 'unsubscribe_hooks returns true if the repository was unsubscribed' do
      repository.stub(:unsubscribe_hooks).and_return(true)
      expect(repository.send(:unsubscribe_hooks)).to eq(true)
    end

    it 'unsubscribe_hooks returns false if the repository was not unsubscribed' do
      expect(repository.send(:unsubscribe_hooks)).to be_false
    end
  end
end
