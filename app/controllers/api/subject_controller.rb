class Api::SubjectController < ApiController

  # http GET "localhost:3000/subject/list"
  def list
    subjects = Subject.all
    render json: {subjects: subjects.as_json}
  end

  # http GET "localhost:3000/subject/get" id==1
  def get
    subject = Subject.find(params[:id])
    render json: {subject: subject.as_json}
  end

  def update
    render json: "ok"
  end

  # http POST "localhost:3000/subject/create" owner_id=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 name=GoodEvent
  def create
    current_profile!

    subject = Subject.create(
      name: params[:name],
      content: params[:content],
      metadata: params[:metadata],
      owner_id: current_address,
      )
    render json: {subject: subject.as_json}
  end

end