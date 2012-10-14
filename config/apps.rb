Padrino.configure_apps do
	set :session_secret, 'a6bd7be58761dd1628a749112edf454fb3f361419c8f622cc7ff64cd5f321fcb'
end

Padrino.mount("JSDetoxWeb").to('/')
