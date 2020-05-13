<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>訂單查詢</title>
<!-- JQuery -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<!-- TWzipcode -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"></script>

<!-- style -->
<link
	href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<script
	src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script
	src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.0.8/css/all.css">
						
<link rel="stylesheet" href="<%=request.getContextPath()%>/static/css/update.css">

<!-- /彈跳視窗 -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@500;700&display=swap" rel="stylesheet">
<script
  src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous">
</script>

<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<!-- 彈跳視窗/ -->
<style>
#span-right {
	float: right;
}

</style>	
</head>
<style>

body { 
	opacity: 0; 
	transition: opacity 2s; 
	font-family: 'Noto Sans TC';

}
.bar{
	padding-right:0 !important;
}
div{
	display:block;
}
.menu_Style {
    height: 1000px;
    width: 300px;
    float: left;
}
#content table{
    background-color: #ffa300;
}

#content table .content_tr .list {
    color: #333;
    background-color: #FFF7E6;
}

</style>
<body onload="document.body.style.opacity='1'">
<jsp:include page="/WEB-INF/views/fragment/indexTOP.jsp" />
<form:form id="orderTable">
<!-- <jsp:include page="/WEB-INF/views/fragment/indexBOTTOM.jsp" />-->
<div id="update-contain" class="update_contain">
	<div id="update-menu" class="menu_Style">
		<div id="menu-head" class="menu_headStyle">
			<div id="img">
			<!-- 點擊圖片跳出彈跳視窗 -->
				<label data-toggle="modal" data-target="#exampleModalCenter">
					<img src="${data.picture}" style="cursor:pointer;width:150px;height: 150px">
				</label>
				<!-- Modal 彈跳視窗內容-->
				<div class="modal fade" id="exampleModalCenter" tabindex="-1"
					role="dialog" aria-labelledby="exampleModalCenterTitle"
					aria-hidden="true">
					<div class="modal-dialog modal-lg" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLongTitle">
									<input type="file"  multiple id="picture">
								</h5>
									
								<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
									<span aria-hidden="true">&times;</span>
								</button>
							</div>
							<div class="modal-body">
								<img id="show" src="" alt="預覽圖片" />
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" onclick="upload()">上傳頭像</button>
							</div>
						</div>
					</div>
				</div>
				<script type="text/javascript">
					//點擊上傳
				function upload(){
					//js接收文件
					var formData = new FormData();
					formData.append("files", $("#picture")[0].files[0]);
					$.ajax({
						url : "http://localhost:8080/FinalProject/upload.action",
						type : "POST",
						data : formData ,
						contentType:false,
					    processData:false,//有必要，不然不行
					    mimeType:"multipart/form-data",
						success : function() {
						window.location.reload("update.jsp")
						}
					})
				}
					
				//用來顯示預覽圖片
				//imgInp(file的ID)
				$("#picture").change(function(){
			   	//當檔案改變後，做一些事 
			 		readURL(this);   // this代表<input id="imgInp">
			 	});
				function readURL(input){
					if(input.files && input.files[0]){
						var reader = new FileReader();
				    	reader.onload = function (e) {
				    //顯示圖片的ID
				      		$("#show").attr('src', e.target.result);
					    }
				    reader.readAsDataURL(input.files[0]);
					}
				}
				</script>
			</div>
		</div>
		
		<div id="menu-content" class="menu_contentStyle"></div>
			<ul>
				<li><span><i class="fa fa-user"></i></span><a
					href="update.action">編輯使用者資訊</a></li>
				<li><span><i class="fa fa-lock"></i></span><a href="<c:url value="/forget.return" />">登入與帳號安全</a></li>
				<li><span><i class="fa fa-file"></i></span><a href="<c:url value="/ordersBymId" />">查詢訂單</a></li>
			</ul>
		</div>
		<div id="header">
			<h2>
				<b>|</b>查詢訂單
			</h2>
		</div>
		
		<div id="content" class="table100-body js-pscroll content_Style">
			<table style="border:2px #1a88ac solid;" cellpadding="6" border='1'>
				<c:forEach var="order" items="${orders}">
					<tbody>	
						<tr class="row100 head">
							<th class="cell100 column1 font-weight-bold" style="border-style:none">訂單編號</th>
							<th class="cell100 column2 font-weight-bold" style="border-style:none">建立日期</th>							
							<th class="cell100 column2 font-weight-bold" style="border-style:none">總金額</th>							
							<th class="cell100 column2 font-weight-bold" style="border-style:none">付款方式</th>
							<th class="cell100 column2 font-weight-bold" style="border-style:none">明細</th>							
							<th class="cell100 column2 font-weight-bold" style="border-style:none">詳細</th>
							<th class="cell100 column2 font-weight-bold" style="border-style:none">
							<span style="font-size:1.4em;" class="fa fa-pencil-square-o"></span></th>		
						</tr>
						<tr class="row100 body">
							<td class="list" style="border-style:none">${order.oSysSn}</td>
							<td class="list" style="border-style:none">${fn:substring(order.createTime, 0, 10)}</td>
							<td class="list" style="border-style:none"><fmt:formatNumber value="${order.price}" pattern="#,###,###" />元</td>
							<c:choose>
								<c:when test="${order.pay==1}">
									<td class="cell100 column2" style="border-style:none">信用卡一次繳清</td>
								</c:when>
								<c:when test="${order.pay==2}">
									<td class="cell100 column2" style="border-style:none">測試付款2</td>
								</c:when>
								<c:otherwise>
								</c:otherwise>
							</c:choose>
							<td class="cell100 column2" style="border-style:none">${order.consignee}</td>
							<td class="cell100 column2" style="border-style:none">
								<a href="<spring:url value='/orderItemByoSysSn?oSysSn=${order.oSysSn}' />" > 
								<span class="link_g" style="text-decoration:underline;color:blue">清單</span></a>
							</td>
							<td class="cell100 column2" style="border-style:none"></td> 									
						</tr> 
						<tr class="row100 body">
							<td class="cell100 column2" style="border-style:none">${order.status}</td>
							<td height="40" colspan="6" align="center" class="content_td">
								<table border="0" align="center" cellpadding="0" cellspacing="0">
									<tbody>
										<tr>
											<td valign="bottom" height="9" align="center">
												<table width="300" border="0" cellspacing="0" cellpadding="0" height="8">
													<tbody>
														<tr>
															<td height="8" bgcolor="ffa300">
																<table border="0" cellspacing="0" cellpadding="0" height="8">
																	<tbody>
																		<tr bgcolor="FFFFFF">
																			<td height="20" width="120">
																				<table width="140" border="0" cellspacing="0" cellpadding="0">
																					<tbody>
																						<tr>
																						<c:choose>
																							<c:when test="${order.status==3}">
																								<td class="bar" bgcolor="#28FF28" width="30" height="20"></td>
																						
																							</c:when>
																							<c:when test="${order.status==1}">
																								<td class="bar" bgcolor="#28FF28" width="30" height="20"></td>
																								<td class="bar" bgcolor="#28FF28" width="30"></td>
																							
																							</c:when>
																							<c:when test="${order.status==4}">
																								<td class="bar" bgcolor="#28FF28" width="30" height="20"></td>
																								<td class="bar" bgcolor="#28FF28" width="30"></td>
																								<td class="bar" bgcolor="#28FF28" width="30"></td>
																							</c:when>
																							<c:otherwise>
																								<td class="bar" bgcolor="#28FF28" width="30" height="20"></td>
																								<td class="bar" bgcolor="#28FF28" width="30"></td>
																								<td class="bar" bgcolor="#28FF28" width="30"></td>
																								<td class="bar" bgcolor="#28FF28" width="30"></td>
																							</c:otherwise>
																						</c:choose>
																							
																						</tr>
																					</tbody>
																				</table>
																			</td>
																		</tr>
																		<tr>
																			<td valign="top" width="200" align="center">
																				<table border="0" cellspacing="0" cellpadding="0" width="630">
																					<tbody>
																						<tr valign="bottom" class="text11" align="center">
																							<td width="100" height="16">
																								<font color="#003399">收到訂單</font>
																							</td>
																							<td width="100">
																								<font color="#003399">已出貨</font>
																							</td>
																							<td width="100">
																								<font color="#003399">物流中</font>
																							</td>
																							<td width="100">
																								<font color="#003399">已送達</font>
																							</td>
																						</tr>
																					</tbody>
																				</table>
																			</td>
																		</tr>
																	</tbody>
																</table>
															</td>
														</tr>
													</tbody>
												</table>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</c:forEach> 
   			 </table>		
		</div>
	</div>	
</div>
</form:form>
</body>
</html>