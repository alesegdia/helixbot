
package plugins;

class Plugin {

	public function OnChatReceived( message:String ):Void {
		if( this.OnValidChat(message) )
		{
			this.OnValidChat(message);
		}
	}

	public function OnValidChat( message:String ):Bool {
		return true;
	}

	public function Step():Void {}

}

