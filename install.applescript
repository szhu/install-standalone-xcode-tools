// https://github.com/substack/node-shell-quote/blob/master/index.js
var quote = function(s) {
    if (s && typeof s === 'object') {
        return quote(s.toString());
    }
    else if (/["\s]/.test(s) && !/'/.test(s)) {
        return "'" + s.replace(/(['\\])/g, '\\$1') + "'";
    }
    else if (/["'\s]/.test(s)) {
        return '"' + s.replace(/(["\\$`!])/g, '\\$1') + '"';
    }
    else {
        return String(s).replace(/([#!"$&'()*,:;<=>?@\[\\\]^`{|}])/g, '\\$1');
    }
}

var chooseDmg = function(app) {
    return app.chooseFile({
    	withPrompt: 'Download xcode_3.2.6_and_ios_sdk_4.3.dmg from developer.apple.com, then select it:',
    	ofType: ['dmg', 'com.apple.disk-image-udif']
    });
}

var mountAndGetPath = function(app, dmg) {
	// http://osxdaily.com/2011/12/17/mount-a-dmg-from-the-command-line-in-mac-os-x/
	var result = app.doShellScript(`hdiutil attach ${quote(dmg)}`);

    temp = result.replace(/\r/g, '\n').split('\n');
    return temp[temp.length - 1].split('\t', 3)[2];
}

app = Application.currentApplication();
app.includeStandardAdditions = true;
var dmg = chooseDmg(app);
var volume = mountAndGetPath(app, dmg);

console.log(app.doShellScript(`
set -xe
tmp="$TMPDIR/xcodedevtools.$$"
mkdir "$tmp"
xar -xf ${quote(volume + '/Packages/DeveloperTools.pkg')} -C "$tmp"
ditto -x "$tmp/Payload" ~/Developer
`));
