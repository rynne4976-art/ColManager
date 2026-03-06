package Controller;

import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;

/**
 * WebSocket 핸드셰이크 시 HTTP 세션을 WebSocket 세션으로 전달하는 Configurator.
 * ChatController에서 로그인된 사용자 정보(name, role)를 읽을 수 있게 한다.
 */
public class ChatConfigurator extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig config,
                                HandshakeRequest request,
                                HandshakeResponse response) {
        HttpSession httpSession = (HttpSession) request.getHttpSession();
        if (httpSession != null) {
            config.getUserProperties().put("httpSession", httpSession);
        }
    }
}
