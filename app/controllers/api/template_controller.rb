class Api::TemplateController < ApiController

  # http GET "localhost:3000/template/list"
  def list
    templates = BadgeTemplate.all
    render json: {templates: templates.as_json}
  end

  # http GET "localhost:3000/template/get" id==1
  def get
    template = BadgeTemplate.find(params[:id])
    render json: {template: template.as_json}
  end

  def update
    template = BadgeTemplate.find(params[:id])
    template.update(image_url: params[:image_url],content: params[:content],metadata: params[:metadata],)
    render json: {template: template.as_json}
  end

  # http POST "localhost:3000/template/create" owner_id=0x7682Ba569E3823Ca1B7317017F5769F8Aa8842D4 name=GoodBadgeTemplate
  def create
    # p current_profile!
    p current_address

    template = BadgeTemplate.create(
      name: params[:name],
      content: params[:content],
      image_url: params[:image_url],
      metadata: params[:metadata],
      owner_id: params[:owner_id],
      )
    render json: {template: template.as_json}
  end

end
