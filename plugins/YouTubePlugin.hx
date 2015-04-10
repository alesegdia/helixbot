
package plugins;

import plugins.Plugin;
import haxe.Http;

class YouTubePlugin extends Plugin
{

	public function new() {}
	private var lastName:String;

	override public function OnChatReceived( message:String, sender:String ):Void {
		var r = ~/(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/ ]{11})/i;
		if( r.match(message) )
		{
			var videoid = r.matched(1);
			var query = bot.db.ytdata.find({videoid: videoid});
			var count:Int = 1;
			if( query.hasNext() )
			{
				var elem = query.next();
				count = Std.parseInt(elem.count) + 1;
				bot.db.ytdata.update(elem, { videoid:videoid, count:count });
			}
			else
			{
				bot.db.ytdata.insert({ videoid:videoid, count:count });
			}
			bot.Say("[YouTube] " + this.GetVideoTitleFromID(videoid) + '. Pasted $count times in my presence.');
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
