class TestsController < Simpler::Controller

  def index
    @time = Time.now

    status 201
    headers['Content-Type'] = 'text/plain'
    headers['Custom-Data'] = 'data'
    render plain: 'Plain text response!'
  end

  def show
    @params = params
  end

  def create; end

end
