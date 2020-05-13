package sampple.config.websocket;

import java.io.IOException;
import java.util.HashMap;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

import javax.websocket.EncodeException;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import org.apache.log4j.Logger;

import sampple.config.websocket.model.Message;
import sampple.controller.CustomerService;

@ServerEndpoint(value = "/chat/{name}/{email}", decoders = MessageDecoder.class, encoders = MessageEncoder.class)
public class ChatEndPoint {
	
	private static final Logger logger = Logger.getLogger(ChatEndPoint.class);

	private Session session;
	private static Set<ChatEndPoint> chatEndpoints = new CopyOnWriteArraySet<>();
	private static HashMap<String, String> users = new HashMap<>();
	
	private String chatlog = "";

	@OnOpen
	public void onOpen(Session session, @PathParam("name") String name, @PathParam("email") String email) {
		logger.info("User: " + name + " join chatroom!");
		this.session = session;
		chatEndpoints.add(this);
		users.put(session.getId(), name);
		users.put(name, email);
		Message message = new Message();
		message.setFrom(email);
		message.setName(name);
		message.setSysMsg(message.getName() + "加入了對話");
		broadcast(message);
	}

	@OnMessage
	public void onMessage(Session session, Message message) {
		String name = users.get(session.getId());
		String email = users.get(name);
		logger.info("User: " + name + " say :" + message.getContent());
		message.setFrom(email);
		message.setName(name);
		broadcast(message);
		String user = "<user>" + name + "</user>";
		String content = "<content>" + message.getContent() + "</content>";
		chatlog = chatlog + user + content;
		logger.info(chatlog);
	}

	@OnClose
	public void onClose(Session session) {
		logger.info(">>>>>>>>>>>>>>>>關閉對話!");
		chatEndpoints.remove(this);
		String name = users.get(session.getId());
		String email = users.get(name);
		Message message = new Message();
		message.setFrom(email);
		message.setName(name);
		message.setSysMsg(name + "離開了對話");
		broadcast(message);
		
		// insert db
		CustomerService cs = new CustomerService();
		cs.logOut(message, chatlog);
	}

	@OnError
	public void onError(Session session, Throwable throwable) {
	}

	private static void broadcast(Message message) {
		chatEndpoints.forEach(endpoint -> {
			synchronized (endpoint) {
				try {
					endpoint.session.getBasicRemote().sendObject(message);
				} catch (IOException | EncodeException e) {
					logger.error(e);
				}
			}
		});
	}
}
