package websockets;

import jakarta.websocket.*;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@ServerEndpoint("/chatServer")
public class ChatServer {
    private static final Set<Session> userSessions = Collections.synchronizedSet(new HashSet<>());

    @OnOpen
    public void onOpen(Session session) {
        userSessions.add(session);
        System.out.println("Session opened: " + session.getId());
    }

    @OnClose
    public void onClose(Session session) {
        userSessions.remove(session);
        System.out.println("Session closed: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        for(Session s : userSessions) {
            s.getAsyncRemote().sendText(message);
        }
    }

}
