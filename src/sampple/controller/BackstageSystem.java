package sampple.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import sampple.model.Orders;
import sampple.model.OrdersDetail;
import sampple.model.Uinfo;
import sampple.model.service.OrdersDetailService;
import sampple.model.service.OrdersService;
import sampple.model.service.UinfoService;
import sampple.model.service.UsersService;

@Controller
public class BackstageSystem {

	private static final Logger logger = Logger.getLogger(BackstageSystem.class);

	private OrdersService ordersService;
	private OrdersDetailService ordersDetailService;
	private UsersService usersService;
	private UinfoService uinfoService;

	private static final String BACKSTAGE_PAGE = "Backstage";
	private static final String BACKSTAGEORDER_PAGE = "BackstageOrder";
	private static final String BACKSTAGEUSERS_PAGE = "BackstageUsers";

	@Autowired
	public BackstageSystem(OrdersService ordersService, OrdersDetailService ordersDetailService,
			UsersService usersService, UinfoService uinfoService) {
		this.ordersService = ordersService;
		this.ordersDetailService = ordersDetailService;
		this.usersService = usersService;
		this.uinfoService = uinfoService;
	}

	@GetMapping(path = "/back")
	public String processLoginBack(Model model) {
		SimpleDateFormat myFmt = new SimpleDateFormat("yyyy/MM/dd");
		Date now = new Date();
		String today = myFmt.format(now);
		Date befor = new Date(now.getTime() - (long) 1 * 24 * 60 * 60 * 1000);// 昨天的日期
		String yesterday = myFmt.format(befor);
		logger.info(today);
		logger.info(yesterday);

		Long todayOrder = ordersService.queryOrderCount(today);
		Long yesterdayOrder = ordersService.queryOrderCount(yesterday);
		Long orderPay = ordersService.queryOrderPayCount();
		Long orderProduct = ordersService.queryOrderStatusCount();
		int todaySale = (int) ordersService.queryOrderSum(today);
		int yesterdaySale = (int) ordersService.queryOrderSum(yesterday);
		logger.info(todayOrder);
		logger.info(yesterdayOrder);
		model.addAttribute("todaySale", todaySale);
		model.addAttribute("yesterdaySale", yesterdaySale);
		model.addAttribute("todayOrder", todayOrder);
		model.addAttribute("yesterdayOrder", yesterdayOrder);
		model.addAttribute("orderPay", orderPay);
		model.addAttribute("orderProduct", orderProduct);
		return BACKSTAGE_PAGE;
	}

	@GetMapping(path = "/back/order")
	public String processBackOrder() {
		return BACKSTAGEORDER_PAGE;
	}

	@GetMapping(path = "/back/users")
	public String processBackUsers() {
		return BACKSTAGEUSERS_PAGE;
	}

	@PostMapping(path = "/back/order.change")
	public String processBackOrderChange(Model model, @RequestParam("oSysSn") int oSysSn,
			@RequestParam("uSysSn") int uSysSn, @RequestParam("status") int status, @RequestParam("price") int price,
			@RequestParam("consignee") String consignee, @RequestParam("addr") String addr,
			@RequestParam("pay") String pay, @RequestParam("payStatus") String payStatus,
			@RequestParam("createTime") String createTime, @RequestParam("updateTime") String updateTime) {
		SimpleDateFormat myFmt = new SimpleDateFormat("yyyy-MM-dd");
		Date now = new Date();
		String update = myFmt.format(now);
		logger.info(update);
		Orders orders = new Orders(oSysSn, uSysSn, status, price, consignee, addr, pay, payStatus, createTime, update);
		ordersService.update(orders);

		return "redirect:/back/order";
	}

	@PostMapping(path = "/back/users.change")
	public String processBackUsersChange(Model model, @RequestParam("email") String email,
			@RequestParam("utype") String utype, @RequestParam("deleteFlag") String deleteFlag) {

		usersService.updateDeleteFlag(email, deleteFlag, utype);

		return "redirect:/back/users";
	}

	@GetMapping(path = "/allOrdersJson")
	public String processAllOrdersJsonAction(ModelMap model) {
		List<Orders> allOrder = ordersService.allOrder();

		model.addAttribute("allOrder", allOrder);

		return null;
	}

	@GetMapping(path = "/allUsersJson")
	public String processAllUsersJsonAction(ModelMap model) {
		List<Uinfo> allUsers = uinfoService.queryAllInfo();

		List<OrdersDetail> allOrdersDetail = ordersDetailService.queryAllODtl();

		model.addAttribute("allUsers", allUsers);

		return null;
	}

}
