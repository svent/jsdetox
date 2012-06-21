class JSDetoxWeb < Padrino::Application
	register SassInitializer
	register Padrino::Rendering
	register Padrino::Mailer
	register Padrino::Helpers
	register Padrino::Cache

	use Rack::Session::Pool

	get "/" do
		redirect url(:analysis, :index)
	end

end
