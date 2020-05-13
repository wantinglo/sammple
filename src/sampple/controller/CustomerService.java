package sampple.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import sampple.config.websocket.model.Message;
import sampple.model.CusServ;
import sampple.model.Users;
import sampple.model.service.CusServService;
import sampple.model.service.UsersService;

@Controller
public class CustomerService {

	private String status = "0";

	private static final Logger logger = Logger.getLogger(CustomerService.class);

	@GetMapping("/chat")
	public void chat(HttpServletRequest request, HttpServletResponse response, Model model) {
		logger.info("status = " + status);
		String rtnMsg = "";
		if (status.equals("0")) {
			HttpSession session = request.getSession();
			Users mb = (Users) session.getAttribute("identity");
			if (mb != null) {
				status = "1";
				session.setAttribute("email", mb.getEmail());
				session.setAttribute("name", mb.getUinfo().getName());
				rtnMsg = "{\"success\":\"開啟對話\"}";
			} else {
				rtnMsg = "{\"login\":\"請先登入\"}";
			}
		} else {
			rtnMsg = "{\"fail\":\"客服忙線中\"}";
		}

		PrintWriter out = null;
		response.setContentType("application/json");
		StringBuilder jsonString = new StringBuilder();
		try {
			out = response.getWriter();
			jsonString.append(rtnMsg);
			out.print(jsonString.toString());
			out.flush();
		} catch (IOException e) {
			logger.error(e);
		}
	}

	@RequestMapping(path = "/customer")
	public String cusCreateChat(HttpServletRequest request) {
		HttpSession session = request.getSession();
		Users mb = (Users) session.getAttribute("identity");
		if (mb != null) {
			session.setAttribute("email", mb.getEmail());
			session.setAttribute("name", mb.getUinfo().getName());
		}
		return "chatroom";
	}

	public void logOut(Message message, String chatlog) {
		status = "0";

		String email = message.getFrom();
		try {
//			Session session = sessionFacotry.getCurrentSession();
//			Query<Users> query = session.createQuery("from Users where EMAIL=:email", Users.class);
//			query.setParameter("email", email);
//			int sysSn = query.getSingleResult().getSysSn();
			
			CusServ csMain = new CusServ();

			csMain.setStatus("0");
//			csMain.setuSysSn(sysSn);
			csMain.setContent(chatlog);

			CusServService csService = new CusServService();
			csService.insert(csMain);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
