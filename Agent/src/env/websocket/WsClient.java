package environment.websocket;

import java.net.URI;
import java.net.URISyntaxException;
import java.nio.ByteBuffer;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_6455;
import org.java_websocket.handshake.ServerHandshake;

import environment.websocket.WsClientMsgHandler;

public class WsClient extends WebSocketClient {

	private WsClientMsgHandler msgHandler;

	public WsClient(URI serverUri, Draft draft) {
		super(serverUri, draft);
	}

	public WsClient(URI serverURI) {
		super(serverURI);
	}

	public void setMsgHandler(WsClientMsgHandler handler){
		this.msgHandler = handler;
	}

	@Override
	public void onOpen(ServerHandshake handshakedata) {
		// send("Hello, it is me. Mario :)");
		System.out.println("[WsClient] new connection opened");
	}

	@Override
	public void onClose(int code, String reason, boolean remote) {
		System.out.println("closed with exit code " + code + " additional info: " + reason);
	}

	@Override
	public void onMessage(String message) {
		// System.out.println("received message: " + message);
		if (msgHandler != null){
			msgHandler.handleMsg(message);
		}
	}

	@Override
	public void onMessage(ByteBuffer message) {
		System.out.println("received " + message);
	}

	@Override
	public void onError(Exception ex) {
		System.err.println("an error occurred:" + ex);
	}

	// public static void main(String[] args) throws URISyntaxException {		
	// 	WebSocketClient client = new EmptyClient(new URI("ws://localhost:8887"));
	// 	client.connect();
	// }
}