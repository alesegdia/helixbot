
package plugins;

import IRCBot;

class Plugin {

	public var bot(default, default):IRCBot;
	public function OnChatReceived( message:String, sender:String ):Void {}
	public function Step():Void {}

}

