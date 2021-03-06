RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  #config.authenticate_with do
  #  warden.authenticate! scope: :user
  #end
  #config.current_user_method(&:current_user)

  ## == Cancan ==
  #config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  # 临时解决方法，cancancan无法使用，在app/models/ability.rb的Ability.initialize(user)方法中，user无法传入始终为空
  config.authorize_with do |controller|
     unless current_user.try(:has_role?, :admin)
       flash[:alter] = '没有权限进行操作'
       redirect_to main_app.root_path
     end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'User' do
    list do
      field :id
      field :name
      field :realname
      field :email
      field :school
      field :team
      field :roles
      field :sign_in_count
      field :last_sign_in_at
      field :last_sign_in_ip
      field :current_sign_in_at
      field :current_sign_in_ip
    end
  end
end
