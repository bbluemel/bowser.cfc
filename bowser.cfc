component output=false {
	

/*!
 * Bowser - a browser detector
 * https://github.com/ded/bowser
 * MIT License | (c) Dustin Diaz 2015
 */
/*
!function (root, name, definition) {
	if (typeof module != 'undefined' && module.exports) module.exports = definition()
	else if (typeof define == 'function' && define.amd) define(name, definition)
	else root[name] = definition()
}(this, 'bowser', function () {*/
	/**
		* See useragents.js for examples of navigator.userAgent
		*/

	function init() {

	}

	function detect(ua) {

		var test = function (regex) {
			var match = ReMatchNoCase(regex, ua);
			return ArrayLen(match) > 0;
		}
		var testCS = function(regex) {
			var match = ReMatch(regex, ua);
			return ArrayLen(match) > 0;
		}

		var getFirstMatch = function (regex) {

			var pattern = createObject("java", "java.util.regex.Pattern");
			var compiled = pattern.compile(regex, pattern.CASE_INSENSITIVE);
			var matcher = compiled.matcher(ua);
			while (matcher.find()){
				var current = matcher.group(1);
				return current;
			}

			return '';
		}

		var getSecondMatch = function (regex) {
			var pattern = createObject("java", "java.util.regex.Pattern");
			var compiled = pattern.compile(regex, pattern.CASE_INSENSITIVE);
			var matcher = compiled.matcher(ua);
			while (matcher.find()){
				var current = matcher.group(2);
				return current;
			}

			return '';
		}

		var doReplace = function(s, regex, replacement, scope) {
			return ReReplace(s, regex, replacement, scope);
		}

		var iosdevice = getFirstMatch("(ipod|iphone|ipad)").toLowerCase();
		var likeAndroid = test("like android");
		var android = !likeAndroid && test("android");
		var nexusMobile = test("nexus\s*[0-6]\s*");
		var nexusTablet = !nexusMobile && test("nexus\s*[0-9]+");
		var chromeos = testCS("CrOS");
		var silk = test("silk");
		var sailfish = test("sailfish");
		var tizen = test("tizen");
		var webos = test("(web|hpw)os");
		var windowsphone = test("windows phone");
		var samsungBrowser = test("SamsungBrowser");
		var windows = !windowsphone && test("windows");
		var mac = !Len(iosdevice) && !silk && test("macintosh");
		var linux = !android && !sailfish && !tizen && !webos && test("linux");
		var edgeVersion = getSecondMatch("edg([ea]|ios)\/(\d+(\.\d+)?)");
		var versionIdentifier = getFirstMatch("version\/(\d+(\.\d+)?)");
		var tablet = test("tablet/i.test(ua) && !/tablet pc");
		var mobile = !tablet && test("[^-]mobi");
		var xbox = test("xbox");
		var result;

		if (test("opera")) {
			//  an old Opera
			result = {
				name: 'Opera'
			, opera: true
			, version: Len(versionIdentifier) ? versionIdentifier : getFirstMatch("(?:opera|opr|opios)[\s\/](\d+(\.\d+)?)")
			}
		} else if (test("opr\/|opios")) {
			// a new Opera
			result = {
				name: 'Opera'
				, opera: true
				, version: getFirstMatch("(?:opr|opios)[\s\/](\d+(\.\d+)?)") || versionIdentifier
			}
		}
		else if (test("SamsungBrowser")) {
			result = {
				name: 'Samsung Internet for Android'
				, samsungBrowser: true
				, version: Len(versionIdentifier) ? versionIdentifier : getFirstMatch("(?:SamsungBrowser)[\s\/](\d+(\.\d+)?)")
			}
		}
		else if (test("coast")) {
			result = {
				name: 'Opera Coast'
				, coast: true
				, version: Len(versionIdentifier) ? versionIdentifier : getFirstMatch("(?:coast)[\s\/](\d+(\.\d+)?)")
			}
		}
		else if (test("yabrowser")) {
			result = {
				name: 'Yandex Browser'
			, yandexbrowser: true
			, version: Len(versionIdentifier) ? versionIdentifier : getFirstMatch("(?:yabrowser)[\s\/](\d+(\.\d+)?)")
			}
		}
		else if (test("ucbrowser")) {
			result = {
					name: 'UC Browser'
				, ucbrowser: true
				, version: getFirstMatch("(?:ucbrowser)[\s\/](\d+(?:\.\d+)+)")
			}
		}
		else if (test("mxios")) {
			result = {
				name: 'Maxthon'
				, maxthon: true
				, version: getFirstMatch("(?:mxios)[\s\/](\d+(?:\.\d+)+)")
			}
		}
		else if (test("epiphany")) {
			result = {
				name: 'Epiphany'
				, epiphany: true
				, version: getFirstMatch("(?:epiphany)[\s\/](\d+(?:\.\d+)+)")
			}
		}
		else if (test("puffin")) {
			result = {
				name: 'Puffin'
				, puffin: true
				, version: getFirstMatch("(?:puffin)[\s\/](\d+(?:\.\d+)?)")
			}
		}
		else if (test("sleipnir")) {
			result = {
				name: 'Sleipnir'
				, sleipnir: true
				, version: getFirstMatch("(?:sleipnir)[\s\/](\d+(?:\.\d+)+)")
			}
		}
		else if (test("k-meleon")) {
			result = {
				name: 'K-Meleon'
				, kMeleon: true
				, version: getFirstMatch("(?:k-meleon)[\s\/](\d+(?:\.\d+)+)")
			}
		}
		else if (windowsphone) {
			result = {
				name: 'Windows Phone'
			, osname: 'Windows Phone'
			, windowsphone: true
			}
			if (Len(edgeVersion)) {
				result.msedge = true
				result.version = edgeVersion
			}
			else {
				result.msie = true
				result.version = getFirstMatch("iemobile\/(\d+(\.\d+)?)")
			}
		}
		else if (test("msie|trident")) {
			result = {
				name: 'Internet Explorer'
			, msie: true
			, version: getFirstMatch("(?:msie |rv:)(\d+(\.\d+)?)")
			}
		} else if (chromeos) {
			result = {
				name: 'Chrome'
			, osname: 'Chrome OS'
			, chromeos: true
			, chromeBook: true
			, chrome: true
			, version: getFirstMatch("(?:chrome|crios|crmo)\/(\d+(\.\d+)?)")
			, chromeVersion: getFirstMatch("(?:chrome|crios|crmo)\/(\d+(\.\d+)?)")
			}
		} else if (test("edg([ea]|ios)")) {
			result = {
				name: 'Microsoft Edge'
			, msedge: true
			, version: edgeVersion
			}
		}
		else if (test("vivaldi")) {
			result = {
				name: 'Vivaldi'
				, vivaldi: true
				, version: getFirstMatch("vivaldi\/(\d+(\.\d+)?)") ?: versionIdentifier
				, chrome: true
				, chromeVersion: getFirstMatch("(?:chrome|crios|crmo)\/(\d+(\.\d+)?)")
			}
		}
		else if (sailfish) {
			result = {
				name: 'Sailfish'
			, osname: 'Sailfish OS'
			, sailfish: true
			, version: getFirstMatch("sailfish\s?browser\/(\d+(\.\d+)?)")
			}
		}
		else if (test("seamonkey\/")) {
			result = {
				name: 'SeaMonkey'
			, seamonkey: true
			, version: getFirstMatch("seamonkey\/(\d+(\.\d+)?)")
			}
		}
		else if (test("firefox|iceweasel|fxios")) {
			result = {
				name: 'Firefox'
			, firefox: true
			, version: getFirstMatch("(?:firefox|iceweasel|fxios)[ \/](\d+(\.\d+)?)")
			}
			if (test("\((mobile|tablet);[^\)]*rv:[\d\.]+\)")) {
				result.firefoxos = true
				result.osname = 'Firefox OS'
			}
		}
		else if (silk) {
			result =  {
				name: 'Amazon Silk'
			, silk: true
			, version : getFirstMatch("silk\/(\d+(\.\d+)?)")
			}
		}
		else if (test("phantom")) {
			result = {
				name: 'PhantomJS'
			, phantom: true
			, version: getFirstMatch("phantomjs\/(\d+(\.\d+)?)")
			}
		}
		else if (test("slimerjs")) {
			result = {
				name: 'SlimerJS'
				, slimer: true
				, version: getFirstMatch("slimerjs\/(\d+(\.\d+)?)")
			}
		}
		else if (test("blackberry|\bbb\d+") || test("rim\stablet")) {
			result = {
				name: 'BlackBerry'
			, osname: 'BlackBerry OS'
			, blackberry: true
			, version: Len(versionIdentifier) ? versionIdentifier : getFirstMatch("blackberry[\d]+\/(\d+(\.\d+)?)")
			}
		}
		else if (webos) {
			result = {
				name: 'WebOS'
			, osname: 'WebOS'
			, webos: true
			, version: Len(versionIdentifier) ? versionIdentifier : getFirstMatch("w(?:eb)?osbrowser\/(\d+(\.\d+)?)")
			};
			test("touchpad\/") && (result.touchpad = true)
		}
		else if (test("bada")) {
			result = {
				name: 'Bada'
			, osname: 'Bada'
			, bada: true
			, version: getFirstMatch("dolfin\/(\d+(\.\d+)?)")
			};
		}
		else if (tizen) {
			result = {
				name: 'Tizen'
			, osname: 'Tizen'
			, tizen: true
			, version: getFirstMatch("(?:tizen\s?)?browser\/(\d+(\.\d+)?)") ?: versionIdentifier
			};
		}
		else if (test("qupzilla")) {
			result = {
				name: 'QupZilla'
				, qupzilla: true
				, version: getFirstMatch("(?:qupzilla)[\s\/](\d+(?:\.\d+)+)") ?: versionIdentifier
			}
		}
		else if (test("chromium")) {
			result = {
				name: 'Chromium'
				, chromium: true
				, version: getFirstMatch("(?:chromium)[\s\/](\d+(?:\.\d+)?)") ?: versionIdentifier
			}
		}
		else if (test("chrome|crios|crmo")) {

			result = {
				name: 'Chrome'
				, chrome: true
				, version: getFirstMatch("(?:chrome|crios|crmo)\/(\d+(\.\d+)?)")
				, chromeVersion: getFirstMatch("(?:chrome|crios|crmo)\/(\d+(\.\d+)?)")
			}
		}
		else if (android) {
			result = {
				name: 'Android'
				, version: versionIdentifier
			}
		}
		else if (test("safari|applewebkit")) {
			result = {
				name: 'Safari'
			, safari: true
			}
			if (versionIdentifier) {
				result.version = versionIdentifier
			}
		}
		else if (iosdevice) {
			result = {
				name : iosdevice == 'iphone' ? 'iPhone' : iosdevice == 'ipad' ? 'iPad' : 'iPod'
			}
			// WTF: version is not part of user agent in web apps
			if (versionIdentifier) {
				result.version = versionIdentifier
			}
		}
		else if(test("googlebot")) {
			result = {
				name: 'Googlebot'
			, googlebot: true
			, version: getFirstMatch("googlebot\/(\d+(\.\d+))") ?: versionIdentifier
			}
		}
		else {
			result = {
				name: getFirstMatch("^(.*)\/(.*) "),
				version: getSecondMatch("^(.*)\/(.*) ")
		 };
	 }

		// set webkit or gecko flag for browsers based on these engines
		if (!( result.msedge ?: false) && test("(apple)?webkit")) {
			if (test("(apple)?webkit\/537\.36")) {
				result.name = result.name ?: "Blink"
				result.blink = true
			} else {
				result.name = result.name ?: "Webkit"
				result.webkit = true
			}
			if ( !( Len(result.version)) && ( Len(versionIdentifier) ) ) {
				result.version = versionIdentifier
			}
		} else if (!( result.opera ?: false ) && test("gecko\/")) {
			result.name = result.name ?: "Gecko"
			result.gecko = true
			result.version = result.version ?: getFirstMatch("gecko\/(\d+(\.\d+)?)")
		}

		// set OS flags for platforms that have multiple browsers
		if (!(result.windowsphone ?: false ) && (android || ( result.silk ?: false ) )) {
			result.android = true
			result.osname = 'Android'
		} else if (!( result.windowsphone ?: false ) && Len(iosdevice)) {
			result[iosdevice] = true
			result.ios = true
			result.osname = 'iOS'
		} else if (mac) {
			result.mac = true
			result.osname = 'macOS'
		} else if (xbox) {
			result.xbox = true
			result.osname = 'Xbox'
		} else if (windows) {
			result.windows = true
			result.osname = 'Windows'
		} else if (linux) {
			result.linux = true
			result.osname = 'Linux'
		}

		function getWindowsVersion (s) {
			switch (s) {
				case 'NT': return 'NT'
				case 'XP': return 'XP'
				case 'NT 5.0': return '2000'
				case 'NT 5.1': return 'XP'
				case 'NT 5.2': return '2003'
				case 'NT 6.0': return 'Vista'
				case 'NT 6.1': return '7'
				case 'NT 6.2': return '8'
				case 'NT 6.3': return '8.1'
				case 'NT 10.0': return '10'
				default: return 
			}
		}

		result.chrome = result.chrome ?: false;

		// OS version extraction
		var osVersion = '';
		if ( result.windows ?: false ) {
			osVersion = getWindowsVersion(getFirstMatch("Windows ((NT|XP)( \d\d?.\d)?)"))
		} else if (result.windowsphone ?: false) {
			osVersion = getFirstMatch("windows phone (?:os)?\s?(\d+(\.\d+)*)");
		} else if (result.mac ?: false) {
			osVersion = getFirstMatch("Mac OS X (\d+([_\.\s]\d+)*)");
			osVersion = doreplace(osVersion, "[_\s]", '.', "all");
		} else if (Len(iosdevice) ) {
			osVersion = getFirstMatch("os (\d+([_\s]\d+)*) like mac os x");
			osVersion = doreplace(osVersion, "[_\s]", '.', "all");
		} else if (android ?: false) {
			osVersion = getFirstMatch("android[ \/-](\d+(\.\d+)*)");
		} else if (result.webos ?: false ) {
			osVersion = getFirstMatch("(?:web|hpw)os\/(\d+(\.\d+)*)");
		} else if (result.blackberry ?: false ) {
			osVersion = getFirstMatch("rim\stablet\sos\s(\d+(\.\d+)*)");
		} else if (result.bada ?: false ) {
			osVersion = getFirstMatch("bada\/(\d+(\.\d+)*)");
		} else if (result.tizen ?: false) {
			osVersion = getFirstMatch("tizen[\/\s](\d+(\.\d+)*)");
		}
		if (Len(osVersion ?: '' )) {
			result.osversion = osVersion;
			result.majorosversion = ListFirst(osVersion, '.');
		}

		// device type extraction

		var osMajorVersion = ( result.windows ?: ( result.majorosversion ?: '' ) );
		if (
				 tablet
			|| nexusTablet
			|| iosdevice == 'ipad'
			|| (android && (osMajorVersion == 3 || (osMajorVersion >= 4 && !mobile)))
			|| ( result.silk ?: false )
		) {
			result.tablet = true
		} else if (
				 mobile
			|| iosdevice == 'iphone'
			|| iosdevice == 'ipod'
			|| android
			|| nexusMobile
			|| ( result.blackberry ?: false )
			|| ( result.webos ?: false )
			|| ( result.bada ?: false )
		) {
			result.mobile = true
		}

		// Graded Browser Support
		// http://developer.yahoo.com/yui/articles/gbs
		if ( (result.msedge ?: false ) ||
				( ( result.msie ?: false ) && result.version >= 10) ||
				( ( result.yandexbrowser ?: false ) && result.version >= 15) ||
				( ( result.vivaldi ?: false ) && result.version >= 1.0) ||
				( ( result.chrome ?: false ) && result.version >= 20) ||
				( ( result.samsungBrowser ?: false ) && result.version >= 4) ||
				( ( result.firefox ?: false ) && result.version >= 20.0) ||
				( ( result.safari ?: false ) && result.version >= 6) ||
				( ( result.opera ?: false ) && result.version >= 10.0) ||
				( ( result.ios ?: false ) && result.osversion && result.osversion.split(".")[0] >= 6) ||
				( ( result.blackberry ?: false ) && result.version >= 10.1)
				|| ( ( result.chromium ?: false ) && result.version >= 20)
				) {
			result.a = true;
		}
		else if (( ( result.msie ?: false ) && result.version < 10) ||
				( ( result.chrome ?: false ) && result.version < 20) ||
				( ( result.firefox ?: false ) && result.version < 20.0) ||
				( ( result.safari ?: false ) && result.version < 6) ||
				( ( result.opera ?: false ) && result.version < 10.0) ||
				( ( result.ios ?: false ) && result.osversion && result.osversion.split(".")[0] < 6)
				|| ( ( result.chromium ?: false ) && result.version < 20)
				) {
			result.c = true
		} else result.x = true

		return result
	}
	/*
	var bowser = detect(typeof navigator !== 'undefined' ? navigator.userAgent || '' : '')

	bowser.test = function (browserList) {
		for (var i = 0; i < browserList.length; ++i) {
			var browserItem = browserList[i];
			if (typeof browserItem=== 'string') {
				if (browserItem in bowser) {
					return true;
				}
			}
		}
		return false;
	}
	*/
	/**
	 * Get version precisions count
	 *
	 * @example
	 *   getVersionPrecision("1.10.3") // 3
	 *
	 * @param  {string} version
	 * @return {number}
	 */
	function getVersionPrecision(version) {
		return version.split(".").length;
	}

	/**
	 * Array::map polyfill
	 *
	 * @param  {Array} arr
	 * @param  {Function} iterator
	 * @return {Array}
	 */
	 /*
	function map(arr, iterator) {
		var result = [], i;
		if (Array.prototype.map) {
			return Array.prototype.map.call(arr, iterator);
		}
		for (i = 0; i < arr.length; i++) {
			result.push(iterator(arr[i]));
		}
		return result;
	}*/

	/**
	 * Calculate browser version weight
	 *
	 * @example
	 *   compareVersions(['1.10.2.1',  '1.8.2.1.90'])    // 1
	 *   compareVersions(['1.010.2.1', '1.09.2.1.90']);  // 1
	 *   compareVersions(['1.10.2.1',  '1.10.2.1']);     // 0
	 *   compareVersions(['1.10.2.1',  '1.0800.2']);     // -1
	 *
	 * @param  {Array<String>} versions versions to compare
	 * @return {Number} comparison result
	 */
	function compareVersions(versions) {
		// 1) get common precision for both versions, for example for "10.0" and "9" it should be 2
		var precision = Math.max(getVersionPrecision(versions[0]), getVersionPrecision(versions[1]));
		var chunks = map(versions, function (version) {
			var delta = precision - getVersionPrecision(version);

			// 2) "9" -> "9.0" (for precision = 2)
			version = version + new Array(delta + 1).join(".0");

			// 3) "9.0" -> ["000000000"", "000000009"]
			return map(version.split("."), function (chunk) {
				return new Array(20 - chunk.length).join("0") + chunk;
			}).reverse();
		});

		// iterate in reverse order by reversed chunks array
		while (--precision >= 0) {
			// 4) compare: "000000009" > "000000010" = false (but "9" > "10" = true)
			if (chunks[0][precision] > chunks[1][precision]) {
				return 1;
			}
			else if (chunks[0][precision] === chunks[1][precision]) {
				if (precision === 0) {
					// all version chunks are same
					return 0;
				}
			}
			else {
				return -1;
			}
		}
	}

	/**
	 * Check if browser is unsupported
	 *
	 * @example
	 *   bowser.isUnsupportedBrowser({
	 *     msie: "10",
	 *     firefox: "23",
	 *     chrome: "29",
	 *     safari: "5.1",
	 *     opera: "16",
	 *     phantom: "534"
	 *   });
	 *
	 * @param  {Object}  minVersions map of minimal version to browser
	 * @param  {Boolean} [strictMode = false] flag to return false if browser wasn't found in map
	 * @param  {String}  [ua] user agent string
	 * @return {Boolean}
	 */
	function isUnsupportedBrowser(minVersions, strictMode, ua) {
		var _bowser = bowser;

		// make strictMode param optional with ua param usage
		if (IsString(strictMode)) {
			ua = strictMode;
			strictMode = null;
		}

		if (strictMode === null) {
			strictMode = false;
		}
		if (ua) {
			_bowser = detect(ua);
		}

		var version = "" + _bowser.version;
		for (var browser in minVersions) {
			//if (minVersions.hasOwnProperty(browser)) {
				if (_bowser[browser]) {
					if ( IsString(minVersions[browser])) {
						throw new Error('Browser version in the minVersion map should be a string: ' + browser + ': ' + String(minVersions));
					}

					// browser version and min supported version.
					return compareVersions([version, minVersions[browser]]) < 0;
				}
			//}
		}

		return strictMode; // not found
	}

	/**
	 * Check if browser is supported
	 *
	 * @param  {Object} minVersions map of minimal version to browser
	 * @param  {Boolean} [strictMode = false] flag to return false if browser wasn't found in map
	 * @param  {String}  [ua] user agent string
	 * @return {Boolean}
	 */
	 /*
	function check(minVersions, strictMode, ua) {
		return !isUnsupportedBrowser(minVersions, strictMode, ua);
	}

	bowser.isUnsupportedBrowser = isUnsupportedBrowser;
	bowser.compareVersions = compareVersions;
	bowser.check = check;
*/
	/*
	 * Set our detect method to the main bowser object so we can
	 * reuse it to test other user agents.
	 * This is needed to implement future tests.
	 */
	 /*
	bowser._detect = detect;

	return bowser
	*/

}