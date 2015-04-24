
package plugins;

import plugins.Plugin;
import haxe.Http;

import selecthxml.TypedXml;
using selecthxml.SelectDom;

class CookiePlugin extends Plugin
{

	public function new(){
	}

	//"... opens a cookie: "...". 23 so far!"
	private var rng = new neko.Random();
	override public function OnChatReceived( message:String, sender:String ):Void {
		if( ~/cookiestats/.match(message) )
		{
			var total = bot.db.cookiedata.find({total:1});
			total.hasNext();
			var totalcount = total.next().count;
			bot.Say('$totalcount cookies have been opened in my presence.');
		}
		else if( ~/cookie/.match(message) || ~/galleta/.match(message) )
		{
			var totalQuery = bot.db.cookiedata.find({"total":1});
			if( !totalQuery.hasNext() )
			{
				neko.Lib.println("NO COUNTER! CREATING!");
				bot.db.cookiedata.insert({"total":1, "count":1});
			}
			else
			{
				neko.Lib.println("COUNTER ALREADY CREATED! UPDATING!");
				var prevCount = totalQuery.next().count;
				bot.db.cookiedata.update({"total":1}, {"$set":{"count":prevCount + 1}});
			}

			var countByNick:Int = 1;
			var countQuery = bot.db.cookiedata.find({nick:sender});
			if( countQuery.hasNext() )
			{
				countByNick = countQuery.next().count + 1;
				bot.db.cookiedata.update({nick:sender}, {"$set":{"count":countByNick}});
			}
			else
			{
				neko.Lib.println("NO NICK DATA, CREATING.");
				bot.db.cookiedata.insert({ nick:sender, count:1 });
			}

			var allCookies = bot.db.cookiedata.find({category:"cookies"}).toArray();
			var rand = this.rng.int(allCookies.length-1);
			var selectedCookie = bot.db.cookiedata.find({category:"cookies"}).toArray()[rand].quote;

			bot.Say('$selectedCookie, and $sender has opened $countByNick cookies so far!');
		}
	}

	override public function Step():Void {

	}

	public function ReparseSources():Void
	{
		// fetch page
		var pageHtml = Http.requestUrl("http://en.wikiquote.org/wiki/Shadow_Warrior");

		// replace ':' to let us select
		var r = new EReg("Fortune_say:", "g");
		pageHtml = r.replace(pageHtml, "fortunesay");

		// select last part (cookies)
		var fortunesay = SelectDom.select(TypedXml.parse(pageHtml),"#fortunesay");
		var cookieUL = fortunesay.parent.parent.select("ul:nth-last-of-type(1)")[0];
		for( cookieLI in cookieUL.elementsNamed("li") )
		{
			var r = ~/<li>(.*)<\/li>/;
			if( r.match(cookieLI.toString()) )
			{
				var cookie = r.matched(1);
				if( !bot.db.cookiedata.find({quote: cookie}).hasNext() )
				{
					this.bot.db.cookiedata.insert({quote: cookie, wqpage: "Shadow_Warrior", category: "cookies" });
					neko.Lib.println(cookie);
				}
			}
		}
	}

}
