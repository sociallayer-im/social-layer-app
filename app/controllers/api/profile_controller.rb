class Api::ProfileController < ApiController

  def home
    render json: "ok"
  end

  def signin
    render layout: false
  end

  def nonce
    render json: {nonce: Siwe::Util.generate_nonce}

  end

  def verify
    render json: {result: "ok"}
  end

  def list
    render json: "ok"
  end

  def get
    render json: "ok"
  end

  def update
    render json: "ok"
  end

  def create
    render json: "ok"
  end
end
