
import sys.net.Host;
import sys.net.Socket;
import haxe.io.Error;

class Main {

	public function new() {
		//initialize variables
	}

	private function send( msg:String ):Void {
		socket.write( msg + "\r\n" );
	}

	private function connect( hostUrl:String, port:Int ):Void {
		host = new Host(hostUrl);
		socket.connect(host, port);
		socket.setFastSend(false);
		socket.setTimeout(0);
		socket.setBlocking(true);
	}

	private var host:Host;
	private var socket:Socket = new Socket();

	private function run():Void {
		this.connect("irc.freenode.net", 6667);
		this.send("NICK helix__bot");
		this.send("USER helix__bot 8 * : helix__bot");
		this.send("JOIN " + "#asdf");
		var exitLoop:Bool = false;
		while(!exitLoop)
		{
			var msg:String = this.socket.input.readLine();
			neko.Lib.println(msg);
			var pingregex = ~/PING :.*/;
			var commregex = ~/^:(.*)!.* ([A-Za-z0-9]*) (.*) :(.*)/i;
			if( pingregex.match(msg) )
			{
				this.send("PONG");
			}
			else if( commregex.match(msg) )
			{
				neko.Lib.println("[" + commregex.matched(1) +
						         " " + commregex.matched(2) +
						      " -> " + commregex.matched(3) +
						        "] " + commregex.matched(4) );
			}
		}
	}

	static function main() {
		var main:Main = new Main();
		main.run();
	}

}
