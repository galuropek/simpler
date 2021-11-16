class TestsController < Simpler::Controller

  def index
    status 201
    render plain: 'Plain text response!'
  end

  def create

  end

end
