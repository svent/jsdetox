JSDetoxWeb.controllers :pages do
  KNOWN_PAGES = %w(about)

  get :index, :map => '/*page', :priority => :low do
    begin
      page = params[:page].first
      page.gsub!(/\W+/, '')
      if !KNOWN_PAGES.include?(page)
        render :haml, "%h1 page not found"
      end
      render "pages/#{page}"
    rescue
      render :haml, "%h1 page not found"
    end
  end
end
