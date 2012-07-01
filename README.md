Taist contents:

1. Repository structure
2. TBD Brief description of each part and its logic
3. TBD Dev deployment description
4. TBD Production deployment description

1. Repository structure
/demo_extension - Chrome extension to demonstrate Taist before embedding it directly into the target site
/lib - libraries used by server
/mail_templates - mail templates for manual use
/server - all code for Taist server, responsible both for promo page and taisties API
	/public - static files used on public part of tai.st web site and accessible by everyone directly by url
	/taisties - taistie data not accessible directly
	MainServer.coffee - single starting point for the whole site - both promo page and taisties API
