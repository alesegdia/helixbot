package plugins;

import plugins.Plugin;
import haxe.Http;
import selecthxml.TypedXml;
using selecthxml.SelectDom;

class CulturaChipPlugin extends Plugin
{
	public function new() {}

	override public function OnChatReceived( message:String, sender:String ):Void {
		var r = ~/!latest (topic|post)/;
		if( r.match(message) ) {
			if( r.matched(1) == "post" ) {
				var data:String = Http.requestUrl("http://foro.culturachip.org/extern.php?action=posts_feed&type=rss");
				var latest = SelectDom.select(TypedXml.parse(data), "item")[0];
				trace(latest);
				var post_title:String = SelectDom.select((latest), "title")[0].firstChild().toString();
				var post_message:String = SelectDom.select((latest), "description")[0].firstChild().toString();
				var post_author:String = SelectDom.select((latest), "author")[0].firstChild().toString();
				trace(post_title);
				r = ~/<!\[CDATA\[(.*)\]>/;
				//r = new EReg("", "g");
				if( r.match(post_title) ) {
					post_title = r.matched(1);
				}
				r = ~/<!\[CDATA\[(.*)\]\]>/;
				if( r.match(post_message) ) {
					post_message = r.matched(1);
				}
				r = ~/<!\[CDATA\[ \((.*)\)\]\]>/;
				if( r.match(post_author) ) {
					post_author = r.matched(1);
				}
				var post_link = SelectDom.select(latest, "link")[0].firstChild();
				trace(post_link);
				trace(post_title);
				this.bot.Say(sender + ", latest post by " + post_author + " at " + post_title + ": " + post_message.substr(0,200));
				this.bot.Say(sender + ", more at " + post_link);
			} else if( r.matched(1) == "topic" ) {
				var data:String = Http.requestUrl("http://foro.culturachip.org/extern.php?action=feed&type=rss");
				var latest = SelectDom.select(TypedXml.parse(data), "item")[0];
				trace(latest);
				var post_title:String = SelectDom.select((latest), "title")[0].firstChild().toString();
				trace(post_title);
				r = ~/<!\[CDATA\[\[(.*)\]\]\]>/;
				//r = new EReg("", "g");
				if( r.match(post_title) ) {
					post_title = r.matched(1);
				}
				var post_link = SelectDom.select(latest, "link")[0].firstChild();
				trace(post_link);
				trace(post_title);
				this.bot.Say(sender + ", latest topic is " + post_title + ", link: " + post_link);
			}
		}
	}

}
