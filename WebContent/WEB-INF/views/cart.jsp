<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<!------ Include the above in your HEAD tag ---------->
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>購物車</title>
</head>
<style>
	body {
		background: #7d706f
	}

	.container {
		background: #dadfe1;
		width: 1000px;
		position: relative;
		margin-top: 110px;
	}

	.container h1 {
		text-align: center;
		margin: 10px 0px 10px;

		font-weight: bolder;
	}
	.container th{
	text-align: center;
	 }

.container .td1{
	text-align: center;
	 }

	.delete-btn {
		display: inline-block;
		cursor: pointer;
		width: 18px;
		height: 17px;
		background: url(<%=request.getContextPath()%>/static/css/img/delete-icn.svg) no-repeat center;
		margin-right: 5px;
	}
</style>

<body style="background-color: #7d706f;">
	<%@ include file="./fragment/indexTOP.jsp"%>

	<div class="container">
		<h1>購物車</h1>
		<hr>

		<table class="table table-striped table-hover table-bordered">
			<tr>
				<th style="width: 35%">產品名稱</th>
				<th>顏色</th>
				<th>記憶體</th>
				<th>價錢</th>
				<th colspan="">數量</th>
				<th>刪除</th>
				
			</tr>
			<c:forEach varStatus="vs" var="anEntry" items="${ShoppingCart.content}">
				<tbody>
					<tr>
						
						<td class="td1">${anEntry.value.pName}</td>
						<td class="td1">${anEntry.value.color}</td>
						<td class="td1">${anEntry.value.storage}</td>
						
						<td class="td1">
							<fmt:formatNumber value="${anEntry.value.price}" pattern="#,###" />
						</td>
						<td class="td1"><input type="text" class="productId" value="${anEntry.key}" hidden="hidden">
							<button class="plus-btn" type="button" name="button">
								<img src="<c:url value='/static/img/plus.svg' />" />
							</button> <input id="${vs.index}qty" class="newQty" type="number" name="name"
								value="${anEntry.value.quantity}">
							<button class="minus-btn" type="button" name="button">
								<img src="<c:url value='/static/img/minus.svg' />" />
							</button></td>
							<td class="td1">
							<a class="delete-btn" onclick="return cancelProduct(${anEntry.key})"></a>
						</td>
					</tr>
				</tbody>
				<input type="text" id="oItem" value="${ShoppingCart.content}" disabled hidden="hidden">
			</c:forEach>
			<tr>

			</tr>
			<tr>
				<td><a href="<%=request.getContextPath()%>/productC/phone" class="pull-left btn btn-secondary"
						style="background-color:#7d706f;color:white; ">Continue
						Shopping</a></td>
				<td class="cart_total" colspan="3" style="text-align: right">Total：
					<fmt:formatNumber value="${ShoppingCart.subtotal}" pattern="#,###" />元
				</td>
				<td  colspan="2"><input id="checkOut"  type="button" class="pull-right btn btn-secondary"
						style="background: #7d706f;color:white;" value="Checkout"><Checkout/td>
			</tr>
		</table>


	</div>

	<c:if test="${errorMsg != null}">
		<input id="error" type="text" value="${errorMsg}" hidden="hidden">
		<script>
			var error = $('#error').val();
			alert(error);
		</script>
	</c:if>
	</div>

	<script type="text/javascript">
		$('.minus-btn').on('click', function (e) {
			e.preventDefault();
			var $this = $(this);
			var $input = $this.prev();
			var value = parseInt($input.val());
			if (value > 1) {
				value = value - 1;
			} else {
				value = 1;
			}
			$input.val(value);

			var pId = $(this).closest("td").find(".productId").val();
			var newQty = value;
			console.log(pId);

			$.ajax({
				type: "GET",
				url: "modifyQty?pName=" + pId + "&newQty=" + newQty,
				success: function (data) {
					if (data.hasOwnProperty('error')) {
						alert(data["error"]);
						$input.val(data["stock"]);
						ajax_modifyQty(pId, data["stock"]);
					} else {
						console.log("success");
						$(".cart_total").html("Total： " + data + "元");
					}
				}
			});
		});

		$('.plus-btn').on('click', function (e) {
			e.preventDefault();
			var $this = $(this);
			var $input = $this.next();
			var value = parseInt($input.val());
			if (value < 100) {
				value = value + 1;
			} else {
				value = 100;
			}
			$input.val(value);
			var pId = $(this).closest("td").find(".productId").val();
			var newQty = value;
			console.log(pId);

			$.ajax({
				type: "GET",
				url: "modifyQty?pName=" + pId + "&newQty=" + newQty,
				success: function (data) {
					//     				var error = JSON.parse(data);
					if (data.hasOwnProperty('error')) {
						alert(data["error"]);
						$input.val(data["stock"]);
						ajax_modifyQty(pId, data["stock"]);
					} else {
						console.log("success");
						$(".cart_total").html("Total： " + data + "元");
					}
				}
			});
		});


		$('.newQty').change(function (e) {
			var newQty_Input = $(this).closest("td").find(".newQty");
			var newQty = $(this).closest("td").find(".newQty").val();
			var pId = $(this).closest("td").find(".productId").val();
			$.ajax({
				type: "GET",
				url: "modifyQty?pName=" + pId + "&newQty=" + newQty,
				success: function (data) {
					if (data.hasOwnProperty('error')) {
						alert(data["error"]);
						newQty_Input.val(data["stock"]);
						ajax_modifyQty(pId, data["stock"]);
					} else {
						console.log("success");
						$(".cart_total").html(data + "元");
					}
				}
			});
		});

		$('#checkOut').on('click', function (e) {
			$.ajax({
				type: "GET",
				url: "checkEmpty",
				success: function (data) {
					if (data.hasOwnProperty('error')) {
						alert(data["error"]);
						$input.val(data["stock"]);
					} else if (data.hasOwnProperty('login')) {
						alert(data["login"]);
						window.location.href = "/FinalProject/login.return";
					} else if (data.hasOwnProperty('empty')) { 
						alert(data["empty"]);
					} else if (data.hasOwnProperty('success')) {
						window.location.href = "/FinalProject/checkOut";
					}
				}
			});
		});

		function ajax_modifyQty(pId, newQty) {
			$.ajax({
				type: "GET",
				url: "modifyQty?pName=" + pId + "&newQty=" + newQty,
				success: function (data) {
					if (data.hasOwnProperty('error')) {
						alert(data["error"]);
						$input.val(data["stock"]);
					} else {
						console.log("success");
						$(".cart_total").html("Total： " + data + "元");
					}
				}
			});
		}

	</script>

	<!-- 購物車script -->
	<script type="text/javascript">
		function continueShopping() {
			window.location.href = "home";
		}
		function cancelProduct(pId) {
			if (confirm("你確定要移除嗎?")) {
				document.getElementById("cartForm").action = "<c:url value='/cancelProduct?pName=" + pId + "' />";
				document.getElementById("cartForm").submit();

			}
		}
		function modifyQty(pId, qty, index) {
			let x = index + "qty";
			let newQty = document.getElementById(x).value;
			if (confirm("購買數量將變更為" + newQty + "個，請確認是否更新")) {
				document.getElementById("cartForm").action = "<c:url value='/modifyQty?pName=" + pId + "&newQty=" + newQty + "' />";
				document.getElementById("cartForm").submit();
			}
		}
	</script>
</body>

</html>