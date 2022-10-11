class Api::OrgController < ApiController

  # http GET "localhost:3000/org/get" id==1
  def get
    org = Org.find(params[:id])
    render json: org.as_json
  end

  # http GET "localhost:3000/org/list"
  def list
    orgs = Org.all
    render json: orgs.as_json
  end

  # http POST "localhost:3000/org/create" owner_id=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 name=GoodOrg
  def create
    profile = current_profile!

    org = Org.create(
      name: params[:name],
      owner_id: profile.address,
      image_url: params[:image_url],
      content: params[:content],
      metadata: params[:metadata],
      )
    render json: {org: org.as_json}
  end

  def update
    # profile = Profile.where(address: params[:address]).first
    profile = current_profile!
    org = Org.find(params[:org_id])
    raise ActionController::ActionControllerError.new("access denied") unless org.owner_id == profile.id

    org.update(content: params[:content], image_url: params[:image_url])
    render json: {org: org.as_json}
  end

  # http GET "localhost:3000/org/members" id==1
  def members
    results = Membership.where(id: params[:id]).all
    render json: {members: results.as_json}
  end

  # http POST "localhost:3000/org/add-member" org_id=1 address=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  def add_member
    profile = current_profile!
    org = Org.find(params[:org_id])
    raise ActionController::ActionControllerError.new("access denied") unless org.owner_id == profile.id

    member = Profile.find_by(address: params[:address])
    if member
      unless Membership.find_by(org_id: params[:org_id], profile_id: member.id)
        Membership.create(org_id: params[:org_id], profile_id: member.id)
      end
      render json: {result: "ok"}
    else
      render json: {result: "error", message: "no profile"}
    end
  end

  # http POST "localhost:3000/org/remove-member" org_id=1 address=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  def remove_member
    profile = current_profile!
    org = Org.find(params[:org_id])
    raise ActionController::ActionControllerError.new("access denied") unless org.owner_id == profile.id

    results = Membership.where(org_id: params[:org_id], profile_id: params[:profile_id]).delete_all
    render json: {result: "ok"}
  end

end