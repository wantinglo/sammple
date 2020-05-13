package sampple.controller;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import ecpay.payment.integration.AllInOne;
import ecpay.payment.integration.domain.AioCheckOutOneTime;
import sampple.model.Orders;
import sampple.model.OrdersDetail;
import sampple.model.ShoppingCart;
import sampple.model.Users;
import sampple.model.service.OrdersDetailService;
import sampple.model.service.OrdersService;

@Controller
@SessionAttributes(value = { "ShoppingCart" })
public class Order {
	@Autowired
	private OrdersService orderDao;
	@Autowired
	private OrdersDetailService orderDtlDao;

	private Orders tempOrder;

	private static final Logger logger = Logger.getLogger(Order.class);

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	private String pac = "order/";

	@Autowired
	public Order(OrdersService orderDao, OrdersDetailService orderDtlDao) {
		this.orderDao = orderDao;
		this.orderDtlDao = orderDtlDao;
	}

	@RequestMapping("/ezship")
	public String ezship(Model model, HttpSession session, HttpServletRequest request) {
		Orders order = new Orders();
		String name = request.getParameter("stName");
		String ezShip = "exist";
		request.setAttribute("name", name);
		model.addAttribute("order", order);
		model.addAttribute("ezShip", ezShip);
		return "addOrder";
	}

	@RequestMapping("/addOrder")
	public String persistOrder(Model model, HttpSession session, HttpServletRequest request) {
		ShoppingCart cart = (ShoppingCart) session.getAttribute("ShoppingCart");
		if (cart == null) {
			return "redirect:/";
		}

		model.addAttribute("order", new Orders());
		return "addOrder";
	}

	// 結帳畫面選好相關選項再過來
	@RequestMapping(path = "/insertOrder", method = RequestMethod.POST)
	public String insertOrder(@ModelAttribute("order") Orders orders, Model model, HttpSession session,
			HttpServletRequest req) {

//		產生orders & ordersDetail
		Users users = (Users) session.getAttribute("identity");// =========================看session內存users名稱叫啥
		ShoppingCart cart = (ShoppingCart) session.getAttribute("ShoppingCart");
		Timestamp ct = new Timestamp(System.currentTimeMillis());
		orders.setuSysSn(users.getSysSn());// users
		orders.setPayStatus("N");// N未付款
		orders.setPrice((int) cart.getSubtotal());// 總金額
		orders.setStatus(1);// 1 接收訂單成功
		orders.setCreateTime(sdf.format(ct));

		Set<OrdersDetail> items = new HashSet<>();
		Map<String, OrdersDetail> cartItems = cart.getContent();
		Set<String> set = cartItems.keySet();
		int seq = 1;

		for (String k : set) {
			OrdersDetail ordersDetail = cartItems.get(k);
			ordersDetail.setSeq(seq);
			seq += 1;
			ordersDetail.setOrders(orders);
			items.add(ordersDetail);
			orders.setOrdersDetail(items);
		}

		orderDao.insert(orders);
		if (orders.getPay() == ("1")) {
			return "redirect:/index";
		} else {
			logger.info("進入綠界付款");

			Timestamp ts = new Timestamp(System.currentTimeMillis());

			// EcPay Begin
			AllInOne all = new AllInOne("");
			AioCheckOutOneTime obj = new AioCheckOutOneTime(); // 付款方式信用卡一次付清
			obj.setMerchantID("2000132");
			obj.setMerchantTradeNo("ecPay" + String.valueOf(orders.getoSysSn())); // 訂單編號 20020202 前面補上ecPay
			obj.setMerchantTradeDate(sdf.format(ts)); // 交易時間 yyyy/MM/dd HH:mm:ss
			obj.setTotalAmount(String.valueOf(orders.getPrice())); // 總付款金額

			obj.setTradeDesc("測試sampple交易");// 交易描述
			obj.setItemName("測試sampple商品名稱"); // ob.getOrderItemString()); // 設定商品名稱
			obj.setReturnURL("http://localhost:8080/FinalProject/order/receive");
			obj.setOrderResultURL("http://localhost:8080/FinalProject/order/result"); // EcPay會在付款結束後，將USER
			String form = all.aioCheckOut(obj, null); // null for no invoice //CheckOut內會自己產生驗證碼 CheckMacValue
			model.addAttribute("ecpayForm", form);
			tempOrder = orders;
			return "ecpay";// test
		}
	}

	// for server
	@PostMapping(path = "/order/all")
	public String processServerOrder(@RequestParam("sysSn") String sysSn, Model model) {
		// can query user's order
		Orders result = orderDao.customerQuery(Integer.parseInt(sysSn));
		result.getStatus();
		result.getCreateTime();
		result.getPrice();
		return "";
	}

	// 依會員查全部訂單
	@RequestMapping("/ordersBymId")
	public String selectMemberOrders(Model model, HttpSession session, HttpServletRequest req) {
		logger.info("in ordersBymId");
		Users users = (Users) session.getAttribute("identity");
		logger.info(users.getSysSn());
		List<Orders> o = orderDao.userQuery(users.getSysSn());
		for (Orders g : o) {
			logger.info("SysSn:" + g.getoSysSn());
			logger.info("price:" + g.getPrice());
			logger.info("pay:" + g.getPay());
			logger.info("payStatus:" + g.getPayStatus());
			logger.info("status:" + g.getStatus());
			logger.info("addr:" + g.getAddr());
			logger.info("createtime:" + g.getCreateTime());
			logger.info("CONSIGNEE:" + g.getConsignee());
		}
		model.addAttribute("orders", o);

		return "OrderList";
	}

	// 依訂單編號查細項
	@RequestMapping("/orderItemByoSysSn")
	public String displayItems(@RequestParam("oSysSn") Integer oSysSn, Model model) {
		List<OrdersDetail> o = orderDao.queryDetail(oSysSn);
		for (OrdersDetail g : o) {
			g.setoSysSn(oSysSn); // 先擋著用
			logger.info("oSysSn:" + g.getoSysSn());
			logger.info("pName:" + g.getpName());
			logger.info("seq:" + g.getSeq());
			logger.info("quantity:" + g.getQuantity());
			logger.info("price:" + g.getPrice());

		}
		model.addAttribute("ordersDetail", o);
		logger.info("orderItemByoSysSn OK");
		return "orderDetail";
	}

	public Map<String, String> errMsg(Orders order, ShoppingCart cart) {
		Map<String, String> errorMessage = new HashMap<>();
		if (order.getAddr() == null || order.getAddr().trim().equals("")) {
			errorMessage.put("emptyAddr", "此欄位不可為空白");
		}

		if (cart == null || cart.getContent().size() == 0) {
			errorMessage.put("emptyCart", "請挑選商品");
		}

		return errorMessage;
	}

//ecpay

	@RequestMapping(path = "order/receive", method = RequestMethod.POST) // ReturnURL 測試綠界會被跳過
	public String receive(HttpServletRequest req) {
		System.err.println("=====GOT FROM ECPAY=====");
		logger.info("======Into receive=======");
		Map<String, String[]> map = req.getParameterMap();
		if (map == null || map.size() == 0) {
			logger.info("receive map is empty");
			return pac + "receive";
		}
		Set<String> keySet = map.keySet();
		for (String key : keySet) {
			logger.info(map.get(key));
		}
		System.err.println("=====Receive END=====");
		return "1|OK";// 官方要求成功接到要回傳
	}

	@RequestMapping("order/result") // OrderResultURL
	public String result(HttpServletRequest req, Model model, HttpSession session) {
		System.err.println("=====CLIENT BACK From EcPay=====");
		Map<String, String[]> map = req.getParameterMap();
		logger.info("testorders:" + tempOrder);
		if (map == null || map.size() == 0) { // if the parameter map is null or empty -> Fail to get any information
												// from EcPay
			logger.info("result map is empty");
			model.addAttribute("rtnMsg", new String[] { "Result Map is Empty" });
			System.err.println("!!=====Result Fail=====!!");
			return pac + "fail";
		}
		Set<String> keySet = map.keySet(); // to show all of parameter sent by EcPay on console
		for (String key : keySet) {
			logger.info("==key:" + key + "===");
			for (String s : map.get(key)) {
				logger.info(s);
			}
		}

		String returnCode = map.get("RtnCode")[0].trim();
		if (!returnCode.equals("1")) { // if RtnCode != 1 -> the trade failed.
			logger.info("RtnCode =" + returnCode);
			model.addAttribute("rtnMsg", map.get("RtnMsg"));// 刷卡回傳資訊 RtnMsg 成功為Succeeded
			System.err.println("!!=====Result Fail=====!!");
			return pac + "fail";
		}

		logger.info("RtnCode=1 為成功");
		logger.info("=====以下result回傳的資料=====");
		logger.info("MerchantID:" + map.get("MerchantID"));
		logger.info("MerchantTradeNo:" + map.get("MerchantTradeNo"));
		logger.info("RtnMsg:" + map.get("RtnMsg"));
		logger.info("TradeNo:" + map.get("TradeNo"));
		logger.info("TradeAmt:" + map.get("TradeAmt"));
		logger.info("PaymentDate:" + map.get("PaymentDate"));
		logger.info("PaymentType:" + map.get("PaymentType"));
		logger.info("TradeDate:" + map.get("TradeDate"));
		logger.info("SimulatePaid:" + map.get("SimulatePaid"));
		logger.info("CheckMacValue:" + map.get("CheckMacValue"));
		logger.info("=====以上=====");

		System.err.println("=====更改付款狀態(已啟用)=====");
		tempOrder.setPayStatus("Y");// 將狀態改成已付款
		orderDao.update(tempOrder);

		System.err.println("=====Result END=====");
		// 轉回購物車畫面 顯示已付款

		// 要轉回user查詢訂單畫面 先查user所有訂單
		logger.info("進入首頁");
		return "redirect:/";// 轉回index
	}

}
