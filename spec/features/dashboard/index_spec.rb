require 'spec_helper'

feature 'dashboard' do

  before :each do
    Repository.skip_callback(:create, :before, :subscribe_hooks)
    Repository.skip_callback(:destroy, :before, :unsubscribe_hooks)
  end

  let(:auth) do
    {
      'uid' => '1337',
      'provider' => 'github',
      'info' => {
        'name' => Faker::Name.name,
        'nickname' => Faker::Internet.user_name
      },
      'credentials' => { 'token' => '1234567890000000098765432' }
    }
  end

  let(:user) do
    user = User.build_from_omniauth auth
    user.save
    user
  end

  let!(:repository) do
    Fabricate(
      :repository,
      uid: user.uid,
      name: Faker::Internet.user_name,
      url: Faker::Internet.url,
      user_id: user.id,
      hook_id: Random.new.rand(1..999999)
    )
  end

  let(:repository_list) { public_repositories }

  def public_repo
    Fabricate.build(
      :repository,
      uid: user.uid,
      name: Faker::Internet.domain_word,
      url: Faker::Internet.url,
      user_id: user.id,
      hook_id: Random.new.rand(1..999999)
    )
  end

  def public_repositories
    repositories = []
    5.times { repositories << public_repo }
    repositories
  end

  before do
    User.any_instance.stub(:public_repositories).and_return(repository_list)
    page.set_rack_session(:user_id => user.id)
    visit dashboard_index_path
  end

  scenario 'load previously added repositories ' do
    find("tr[@id='#{repository.name}']")
  end

  scenario 'add new repository', :js do
    click_link 'add repositories'
    repo = repository_list.sample
    within('#add-repos-modal') do
      find("#on_#{repo.name}").click
      click_button 'Close'
    end
    visit dashboard_index_path
    find("##{repo.name}")
  end
end
