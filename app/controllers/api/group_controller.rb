class Api::GroupController < ApiController

  # http GET "localhost:3000/group/get" id==1
  def get
    @group = Profile.find(params[:id])
    raise ActionController::ActionControllerError.new("not a group profile") unless @group.is_group

    render template: "api/group/group"
  end

  # http GET "localhost:3000/group/list"
  def list
    @groups = Profile.where(is_group: true).all

    render template: "api/group/groups"
  end

  # http POST "localhost:3000/group/create" owner_id=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 name=GoodOrg
  def create
    profile = current_profile!

    username = params[:username]
    unless check_profile_username(username)
      render json: {result: "error", message: "invalid username"}
      return
    end

    domain = "#{params[:username]}.sociallayer.im"

    if Profile.find_by(domain: domain)
      render json: {result: "error", message: "group profile domain exists"}
      return
    end

    @group = Profile.create(
      username: username,
      domain: domain,
      token_id: Badge.get_badgelet_namehash(domain),
      image_url: params[:image_url],
      about: params[:about],
      is_group: true,
      group_owner_id: profile.id,
      )
    render template: "api/group/group"
  end

  def update
    profile = current_profile!
    @group = Profile.find(params[:id])
    raise ActionController::ActionControllerError.new("profile is not a group") unless @group.is_group
    raise ActionController::ActionControllerError.new("access denied") unless @group.group_owner_id == profile.id

    @group.update(about: params[:about], image_url: params[:image_url])
    render template: "api/group/group"
  end

  # http GET "localhost:3000/group/members" group_id==1
  def members
    group = Profile.find(params[:group_id])
    raise ActionController::ActionControllerError.new("profile is not a group") unless group.is_group
    members = group.followers
    render json: {members: members.as_json}
  end

  # http POST "localhost:3000/group/add-member" group_id=1 address=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  def add_member
    profile = current_profile!
    group = Profile.find(params[:group_id])
    raise ActionController::ActionControllerError.new("profile is not a group") unless group.is_group
    # raise ActionController::ActionControllerError.new("access denied") unless group.group_owner_id == profile.id

    if Following.find_by(profile_id: profile.id, target_id: group.id)
      render json: {result: "error", message: "membership exists"}
      return
    end
    Following.create(profile_id: profile.id, target_id: group.id, role: 'group_member')
    render json: {result: "ok"}
  end

  # http POST "localhost:3000/group/remove-member" group_id=1 address=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  def remove_member
    profile = current_profile!
    group = Profile.find(params[:group_id])
    # raise ActionController::ActionControllerError.new("access denied") unless group.group_owner_id == profile.id
    raise ActionController::ActionControllerError.new("access denied") unless (group.group_owner_id == profile.id || params[:profile_id] == profile.id)

    results = Following.where(target_id: params[:group_id], profile_id: params[:profile_id]).delete_all
    render json: {result: "ok"}
  end

  def group_invites
    @group_invites = GroupInvite

    if params[:sender_id]
      @group_invites = @group_invites.where(sender_id: params[:sender_id])
    end
    if params[:group_id]
      @group_invites = @group_invites.where(group_id: params[:group_id])
    end
    if params[:receiver_id]
      @group_invites = @group_invites.where(receiver_id: params[:receiver_id])
    end
    if params[:accepted] == '1'
      @group_invites = @group_invites.where(accepted: true)
    end
    if params[:accepted] == '-1'
      @group_invites = @group_invites.where(accepted: false)
    end
    @group_invites = @group_invites.order('id desc').page(params[:page]).per(20)
    render json: {group_invites: @group_invites.as_json}
  end

  def send_invite
    profile = current_profile!
    @group = Profile.find(params[:group_id])
    raise ActionController::ActionControllerError.new("profile is not a group") unless @group.is_group
    raise ActionController::ActionControllerError.new("access denied") unless @group.group_owner_id == profile.id

    params[:receivers].each {|receiver| raise ActionController::ActionControllerError.new("invalid receiver domain name") unless Profile.find_by(domain: receiver) }

    @group_invites = params[:receivers].map {|receiver|
      receiver = Profile.find_by(domain: receiver)
      receiver_id = receiver.id

      invite = GroupInvite.create(
        sender_id: profile.id,
        group_id: @group.id,
        message: params[:message],
        expires_at: (DateTime.now+30.days),
        receiver_id: receiver_id,
        )

      invite
    }

    render json: {group_invites: @group_invites.as_json}
  end

  def accept_invite
    profile = current_profile!
    @group_invite = GroupInvite.find(params[:group_invite_id])
    @group = Profile.find(@group_invite.group_id)
    raise ActionController::ActionControllerError.new("profile is not a group") unless @group.is_group
    raise ActionController::ActionControllerError.new("access denied") unless profile.id == @group_invite.receiver_id
    # todo : check expires_at
    # todo : mint bagelet
    @group_invite.update(accepted: true)
    Following.create(profile_id: profile.id, target_id: @group.id, role: 'group_member')
    render json: {result: "ok"}
  end

end
