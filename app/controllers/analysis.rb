JSDetoxWeb.controllers :analysis do

  layout :analysis

  get :index do
    @orig_code = session[:orig_code]
    @htmldoc = session[:htmldoc]
    @data_raw = session[:data_raw]
    render 'analysis/index'
  end

end
