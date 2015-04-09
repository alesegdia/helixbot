
package plugins;

import plugins.Plugin;
import haxe.Http;

class YouTubePlugin extends Plugin
{

	public function new() {}

	override public function OnValidChat( message:String ):Bool {
		// tells if 'message' would be accepted by this plugin
		return true;
	}

	override public function Step():Void {
	}

	public function GetVideoTitleFromID( ytid:String ):String
	{
		var data:String = Http.requestUrl("http://gdata.youtube.com/feeds/api/videos/NSpoqZVqtCg");
		var doc = Xml.parse(data);
		var xmlname:String = doc.elementsNamed("entry").next().elementsNamed("title").next().firstChild().toString();
		var r = ~/&amp;amp;/g;
		return r.replace(xmlname, "&");
	}

}
