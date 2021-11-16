class TestsController < Simpler::Controller

  def index
    status 201
    headers['Content-Type'] = 'text/plain'
    headers['Custom-Data'] = 'data'
    render plain: 'Plain text response!'
  end

  def create

  end

end
