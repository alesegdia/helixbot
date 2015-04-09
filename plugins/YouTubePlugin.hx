
package plugins;

import plugins.Plugin;
import haxe.Http;

class YouTubePlugin extends Plugin
{

	public function new() {}
	private var lastName:String;

	override public function OnChatReceived( message:String ):Void {
		var r = ~/(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i;
		if( r.match("https://www.youtube.com/embed/QTby08wxVdY?feature=player_detailpage") )
		{
			bot.Say("[YouTube] " + this.GetVideoTitleFromID(r.matched(1)));
		}
	}

	override public function Step():Void {
	}

	public function GetVideoTitleFromID( ytid:String ):String
	{
		var data:String = Http.requestUrl("http://gdata.youtube.com/feeds/api/videos/" + ytid);
		var doc = Xml.parse(data);
		var xmlname:String = doc.elementsNamed("entry").next().elementsNamed("title").next().firstChild().toString();
		var r = ~/&amp;amp;/g;
		return r.replace(xmlname, "&");
	}

}
