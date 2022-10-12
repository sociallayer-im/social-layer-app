class Api::TemplateLibraryController < ApiController

  # http GET "localhost:3000/template/list"
  def list
    @template_libraries = TemplateLibrary.page(params[:page])
    render json: {template_libraries: @template_libraries.as_json}
  end

  # http GET "localhost:3000/template/get" id==1
  def get
    @template_library = TemplateLibrary.find(params[:id])
    render json: {template: @template_library.as_json}
  end

  def update
    template_library = TemplateLibrary.find(params[:id])
    raise ActionController::ActionControllerError.new("access denied") unless template_library.owner_id == current_address

    template_library.update(image_url: params[:image_url],content: params[:content],metadata: params[:metadata],)
    render json: {template_library: template_library.as_json}
  end

  # http POST "localhost:3000/template_library/create" owner_id=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 name=GoodBadgeTemplate
  def create
    profile = current_profile!

    template_library = TemplateLibrary.create(
      title: params[:title],
      content: params[:content],
      image_url: params[:image_url],
      metadata: params[:metadata],
      price: params[:price],
      license: params[:license],
      owner_id: profile.id,
      )
    render json: {template_library: template_library.as_json}
  end

end



  create_table "template_collections", force: :cascade do |t|
    t.string "title"
    t.text "metadata"
    t.text "content"
    t.string "image_url"
    t.integer "template_library_id"
    t.integer "owner_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "template_libraries", force: :cascade do |t|
    t.string "title"
    t.text "metadata"
    t.text "content"
    t.string "image_url"
    t.integer "owner_id"
    t.string "license"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "title"
    t.text "metadata"
    t.text "content"
    t.string "image_url"
    t.string "resource_type"
    t.string "resource_url"
    t.integer "template_collection_id"
    t.integer "template_library_id"
    t.integer "owner_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end