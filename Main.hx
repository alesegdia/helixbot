
import sys.net.Host;
import sys.net.Socket;

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
	}

	private var host:Host;
	private var socket:Socket = new Socket();

	private function run():Void {
		this.connect("irc.vieju.net", 6667);
		this.send("NICK helix");
		this.send("USER helix 8 * : helix");
		this.send("JOIN " + "#asdf");
		var exitLoop:Bool = false;
		while(!exitLoop)
		{
			var msg:String = this.socket.read();
			neko.Lib.println(msg);
		}
	}

	static function main() {
		var main:Main = new Main();
		main.run();
	}

}
