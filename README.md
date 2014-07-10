# CORS Cookie test

A self-contained Dancer app to test Cross-Origin-Resource-Sharing (CORS) and to
inspect how your Headers, Credentials and Cookies flow around and interact with
each other.

## Install & Usage

- git clone https://github.com/isync/cors-cookie-test.git
- cd cors-cookie-test
- plackup app.pl --port=3000

(It's important to run this here with plackup, as HTTP::Server::Simple won't
"grok" the OPTIONS HTTP method.)

Then open http://0.0.0.0:3000/cors/test in your browser

Open Firebug or Web Developer Console to see the important stuff.

Also: make sure you allow third-party cookies (!) when you want to
test setting Cookies.

## Caveat

This is a bit half-baked. Hideki's original has some clever logic going on which
would increment a counter when everything works. But in my port, there's one 
tiny bit broken, and I haven't tracked down which. I used this test-bench to configure
another project where I was able to sort everything out, and then left it as is.
So, dear reader, happy forking.

## Elsewhere

http://www.html5rocks.com/en/tutorials/cors/

## License

GPL v3
