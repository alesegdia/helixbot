
import sys.net.Host;
import sys.net.Socket;
import haxe.io.Error;
import plugins.Plugin;
import plugins.YouTubePlugin;
import plugins.CookiePlugin;
import haxe.Http;

import org.mongodb.Mongo;
import org.mongodb.Collection;
import org.mongodb.Cursor;
import org.mongodb.Database;

class IRCBot {

	// BOT CONFIG
	private var server:String = "irc.freenode.net";
	private var port:Int = 6667;
	private var channel:String = "#asdf";
	private var botName:String = "helix__bot";

	// MONGODB CONFIG
	private var dbname:String = "helixbot";

	private var plugins = new Array<Plugin>();
	private function AddPlugin( plugin:Plugin ):Void
	{
		plugin.bot = this;
		this.plugins.push(plugin);
	}

	private var mongo = new Mongo();
	public var db:Database;

	private var rng = new neko.Random();
	public function new() {
		this.AddPlugin(new YouTubePlugin());
		var wqplugin = new CookiePlugin();
		this.AddPlugin(wqplugin);
		this.db = mongo.getDB(this.dbname);
		this.connect(this.server, this.port);
		wqplugin.ReparseSources();
	}

	public function Say(msg:String):Void {
		//neko.Lib.println("I say: " + msg);
		this.send('PRIVMSG $channel :$msg');
	}

	private function send( msg:String ):Void {
		this.socket.write( msg + "\r\n" );
	}

	private function connect( hostUrl:String, port:Int ):Void {
		this.host = new Host(hostUrl);
		this.socket.connect(host, port);
		this.socket.setFastSend(false);
		this.socket.setTimeout(0);
		this.socket.setBlocking(true);
		this.send('NICK ${this.botName}');
		this.send('USER helix__bot 8 * : ${this.botName}');
		this.send('JOIN ${this.channel}');
	}

	private function StepPlugins():Void {
		for( plugin in this.plugins )
		{
			plugin.Step();
		}
	}

	private function NotifyMessageToPlugins( msg:String, sender:String ):Void {
		for( plugin in this.plugins )
		{
			plugin.OnChatReceived(msg, sender);
		}
	}

	private var host:Host;
	private var socket:Socket = new Socket();

	private function Run():Void {
		var exitLoop:Bool = false;
		while(!exitLoop)
		{
			var msg:String = this.socket.input.readLine();
			neko.Lib.println(msg);
			var pingRegex = ~/PING :.*/;
			var cmdRegex = ~/^:(.*)!.* ([A-Za-z0-9]*) (.*) :(.*)/i;
			if( pingRegex.match(msg) )
			{
				this.send("PONG");
			}
			else if( cmdRegex.match(msg) )
			{
				neko.Lib.println("[" + cmdRegex.matched(1) +
						" " + cmdRegex.matched(2) +
						" -> " + cmdRegex.matched(3) +
						"] " + cmdRegex.matched(4) );
				this.NotifyMessageToPlugins(cmdRegex.matched(4), cmdRegex.matched(1));
			}
			this.StepPlugins();
		}
	}

	static function main() {
		var main:IRCBot = new IRCBot();
		main.Run();
	}

}
