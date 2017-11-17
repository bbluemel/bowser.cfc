# bowser.cfc
A "lazy port" of [bowser](https://github.com/lancedikson/bowser/) for UA sniffing server side in Lucee (or ColdFusion - though it is untested on CF).

## Why?
User Agent detection is generally frowned upon these days, and "feature detection" is generally the way to go.

However, as part of another project that I am working on which uses two build targets in webpack, for modern browsers and legacy browsers also as using `type="module"` and `nomodule` isn't mature enough yet and there is no equivalent for CSS, I decided to port bowser to a CFC, so I could easily serve smaller CSS and JS files to modern browsers, and legacy or unknown browsers would just get the larger files (e.g. with extra prefixes for CSS, and ES5 compatible ways of doing JS) - so no biggie.

## Lazy Port?
I literally whipped this up within about 30 mins, and have done about the same in testing it with browserstack. I expect it will probably error on rarer browser.
I added some small tweaks to it, e.g. so Vivaldi would report `browser.chrome == true` and the `chromeVersion` from it's UA.

## Usage
My exact use-case (to match my modern "browserlist" in webpack):
```javascript
	var browser = new bowser().detect(CGI.USER_AGENT);

	Request.isModernBrowser = (
		( browser.chrome == true && Val( browser.chromeVersion ) >= 60 ) ||
		( browser.name == 'Safari' && Val( browser.version ) >= 10.1 ) ||
		( browser.name == 'Firefox' && Val( browser.version ) >= 54 ) ||
		( browser.name == 'Edge' && Val( browser.version ) >= 15 ) ||
		( browser.osname == 'iOS'  && Val( browser.osversion ) >= 10.3 )
	);
```

## Future
As this fits my exact use case, I will probably only fix issues that I can reproduce, or come across, but PRs are welcome. 