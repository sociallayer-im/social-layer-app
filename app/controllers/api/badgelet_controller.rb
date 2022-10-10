class Api::BadgeletController < ApiController

  # todo : add :page param doc
  # http GET "localhost:3000/badgelet/list"
  # http GET "localhost:3000/badgelet/list" status=pending
  def list
    badges = Badgelet
    if params[:status]
      badges = badges.where(status: params[:status])
    end

    if params[:sender_id]
      badges = badges.where(sender_id: params[:sender_id])
    end
    if params[:receiver_id]
      badges = badges.where(receiver_id: params[:receiver_id])
    end
    if params[:owner_id]
      badges = badges.where(owner_id: params[:owner_id])
    end
    render json: {badgelets: badges.includes(:badge).page(params[:page]).as_json(include: :badge)}
  end

  # http GET "localhost:3000/badgelet/search" title=Good
  def search
    badgelets = Badgelet.joins(:badge).where("title LIKE ?", "%" + params[:title] + "%")

    render json: {badgelets: badgelets.page(params[:page]).as_json(include: :badge)}
  end

  # todo : add :page param doc
  # http GET "localhost:3000/badgelet/get" id==1
  def get
    badgelet = Badgelet.find(params[:id])
    render json: {badgelet: badgelet.as_json(include: :badge)}
  end

end
