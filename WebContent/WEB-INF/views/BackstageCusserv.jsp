<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>backstage</title>
<link rel="stylesheet"href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<style type="text/css">
.sitebody {
	width: 1600px;
	margin: 0 auto;
	font-size: 13px;
}
.header{
　background-color:#FFD4D4;
　height:200px;
　text-align:center;
　line-height:80px;
}
.header2 {
	width: 270px;
	overflow-x: hidden;
	background-color: rgb(54, 61, 77);
	will-change: scroll-position;
	height: 200px;
	text-align: center;
	float: left;
}
.header3 {
	width: 1330px;
	overflow-x: hidden;
	background-color:ghostwhite;
	will-change: scroll-position;
	height: 200px;
	text-align: center;
	line-height: 400px;
	float: left;
}
.row {
	width: 270px;
	overflow-x: hidden;
	background-color: lightsteelblue;
	will-change: scroll-position;
	height: 600px;
	text-align: center;
	line-height: 600px;
	float: left;
}

.put {
	width: 270px;
	height: 100px;
	color:white;
	font-size:20px;
	text-align: left;
	display: flex;
	padding-left: 0.75rem;
	padding-right: 0.5rem;
	background-color: lightsteelblue;
	transition: background-color 0.3s ease 0s;
}
.content{
	float: left;
	width: 1330px;
	height:600px;
	background-color:ghostwhite;
	text-align:center;
}

</style>
</head>
<body>
	<div class="sitebody">
		<div class="header">
			<div class="header2"></div>
			<div class="header3"></div>
		</div>
		<div class="row">
			<div>
				<input class="put" type="button" value="訂單管理" id="order">
			</div>
			<div>
				<input class="put" type="button" value="商品管理" id="product">
			</div>
			<div>
				<input class="put" type="button" value="庫存管理" id="stock">
			</div>
			<div>
				<input class="put" type="button" value="會員管理" id="users">
			</div>
			<div>
				<input class="put" type="button" value="報表分析" id="report">
			</div>
			<div>
				<input class="put" type="button" value="線上客服" id="cusserv">
			</div>			
		</div>	
		<div class="content">
			<div>
			<table  id="demo"></table>
			</div>
		</div>
	</div>
	<script>
		$("#order").click(function() {
			$.getJSON("allOrdersJson.json",function(data) {	
				var txt = "<tr><th>訂單編號<th>會員編號<th>狀態<th>價格<th>付款方式<th>建立時間<th>修改時間";
				if(data.orders!=null){
				for (let i = 0; i < data.orders.length; i++) {
					txt += "<tr><td>"+ data.orders[i].oSysSn;
					txt += "<td>"+ data.orders[i].uSysSn;
					txt += "<td>"+ data.orders[i].status;
					txt += "<td>"+ data.orders[i].price;
					txt += "<td>"+ data.orders[i].pay;
					txt += "<td>"+ data.orders[i].createTime;
					txt += "<td>"+ data.orders[i].updateTime;
					txt += "<td>"+ "<input type='button' id='changeo' value='修改'>";
					txt += "<td>"+ "<input type='button' id='deleteo' value='刪除'>";
					}
				}
			$("#demo").html(txt);
			});
		});
		$("#product").click(function() {
			$.getJSON("allOrdersJson.json",function(data) {
				var txt = "<tr><th>產品編號<th>產品名稱<th>產品敘述<th>價格<th>折扣<th>上下架";
				if(data.orders!=null){
					for (let i = 0; i < data.orders.length; i++) {
						txt += "<tr><td>"+ data.orders[i].oSysSn;
						txt += "<td>"+ data.orders[i].uSysSn;
						txt += "<td>"+ data.orders[i].status;
						txt += "<td>"+ data.orders[i].price;
						txt += "<td>"+ data.orders[i].createTime;
						txt += "<td>"+ data.orders[i].updateTime;
						txt += "<td>"+ "<input type='button' id='changeo' value='修改'>";
						txt += "<td>"+ "<input type='button' id='deleteo' value='刪除'>";
						}
					}
				$("#demo").html(txt);
			});
		});
		$("#stock").click(function() {
			$.getJSON("allOrdersJson.json",function(data) {
				var txt = "<tr><th>產品編號<th>產品名稱<th>庫存數量<th>在途數量";
				if(data.orders!=null){
					for (let i = 0; i < data.orders.length; i++) {
						txt += "<tr><td>"+ data.orders[i].oSysSn;
						txt += "<td>"+ data.orders[i].uSysSn;
						txt += "<td>"+ data.orders[i].status;
						txt += "<td>"+ data.orders[i].price;
						txt += "<td>"+ data.orders[i].createTime;
						txt += "<td>"+ data.orders[i].updateTime;
						txt += "<td>"+ "<input type='button' id='changeo' value='修改'>";
						txt += "<td>"+ "<input type='button' id='deleteo' value='刪除'>";
						}
					}
				$("#demo").html(txt);
			});
		});
		$("#users").click(function() {
			$.getJSON("allOrdersJson.json",function(data) {
				var txt = "<tr><th>會員編號<th>帳號<th>密碼<th>修改<th>是否刪除";
				if(data.orders!=null){
					for (let i = 0; i < data.orders.length; i++) {
						txt += "<tr><td>"+ data.orders[i].oSysSn;
						txt += "<td>"+ data.orders[i].uSysSn;
						txt += "<td>"+ data.orders[i].status;
						txt += "<td>"+ data.orders[i].price;
						txt += "<td>"+ data.orders[i].createTime;
						txt += "<td>"+ data.orders[i].updateTime;
						txt += "<td>"+ "<input type='button' id='changeo' value='修改'>";
						txt += "<td>"+ "<input type='button' id='deleteo' value='刪除'>";
						}
					}
				$("#demo").html(txt);
			});
		});
		$("#report").click(function() {
			$.getJSON("allOrdersJson.json",function(data) {
				var txt = "<tr><th>書籍名稱<th>作者名<th>出版社名<th>出版日期<th>價格";
				if(data.orders!=null){
					for (let i = 0; i < data.orders.length; i++) {
						txt += "<tr><td>"+ data.orders[i].oSysSn;
						txt += "<td>"+ data.orders[i].uSysSn;
						txt += "<td>"+ data.orders[i].status;
						txt += "<td>"+ data.orders[i].price;
						txt += "<td>"+ data.orders[i].createTime;
						txt += "<td>"+ data.orders[i].updateTime;
						txt += "<td>"+ "<input type='button' id='changeo' value='修改'>";
						txt += "<td>"+ "<input type='button' id='deleteo' value='刪除'>";
						}
					}
				$("#demo").html(txt);
			});
		});
		$("#cusserv").click(function() {
			$.getJSON("allOrdersJson.json",function(data) {
				var txt = "<tr><th>客服編號<th>使用者<th>客服內容<th>建立時間";
				if(data.orders!=null){
					for (let i = 0; i < data.orders.length; i++) {
						txt += "<tr><td>"+ data.orders[i].oSysSn;
						txt += "<td>"+ data.orders[i].uSysSn;
						txt += "<td>"+ data.orders[i].status;
						txt += "<td>"+ data.orders[i].price;
						txt += "<td>"+ data.orders[i].createTime;
						txt += "<td>"+ data.orders[i].updateTime;
						txt += "<td>"+ "<input type='button' id='changeo' value='修改'>";
						txt += "<td>"+ "<input type='button' id='deleteo' value='刪除'>";
					}
				}
				$("#demo").html(txt);
			});
		});
	</script>
	<script>
		$("#demo").on("click","#changeo",function() {
			var txt = "<tr><th>訂單編號<th>會員編號<th>狀態<th>價格<th>付款方式<th>建立時間<th>修改時間";

			$("#demo").html(txt);
			});
		$("#demo").on("click","#deleteo",function() {
			if (confirm('是否刪除?'))location.href= 'back';return false;
			});
	</script>
</body>
</html>