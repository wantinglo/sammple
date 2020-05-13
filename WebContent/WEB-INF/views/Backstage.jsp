<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
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
.note{
background-color: #fdfdfe;
border: 1px solid #d0d0d0; 
border-radius: 10px;
font-weight:bold;
color: #7386D5;
text-align: center;
padding: 20px;
}
.note2{
background-color: #fdfdfe;
border: 1px solid #d0d0d0; 
border-radius: 10px;
font-weight:bold;
color: #7386D5;
text-align: center;
padding: 40px;
margin-bottom: 40px;
}
.container{
margin-top: 40px;
}

</style>
</head>
<body>
<%@include file="BackstageUI.jsp" %>
	<div id="content2" >
		<div class="container">
			<div class="row justify-content-around">
			    <div class="col-3 note">			    	
			    	<a>今日銷售額&nbsp;&emsp;<span class="oi oi-dollar"></span></a><br><br><a>$${todaySale}</a><br><br><a>昨日銷售額&emsp;$${yesterdaySale}</a>
			    </div>
			    <div class="col-3 note">
			    	<a>今日訂單數&nbsp;&emsp;<span class="oi oi-document"></span></a><br><br><a>${todayOrder}</a><br><br><a>昨日訂單數&emsp;${yesterdayOrder}</a>
			    </div>
			    <div class="col-3 note">
			    	<a>當前會員人數&nbsp;&emsp;<span class="oi oi-people"></span></a><br><br><a id="totalrigster"></a>
			    </div>
			 </div>
		</div>
		<div class="container">
			<div class="row justify-content-around ">
			    <div class="col-3">
			    	<div class="note2">
			    		<a>訂單尚未付款</a><br><br><a>${orderPay}筆</a><br><br>
			    	</div>
			    	<div class=" note2">
			    		<a>訂單尚未出貨</a><br><br><a>${orderProduct}筆</a><br><br>
			    	</div>	
			    </div>
			    <div class="col-7 note"><a>我想當圓餅圖</a></div>
			 </div>
		</div>
	</div>
	<script>
			$.getJSON("../FinalProject/allUsersJson.json",function(result){
				var txt = 0;
				var str = "N";
				if(result!=null){
					data = eval(result.allUsers);
					for(var i=0;i<data.length;i++){						
						if(str==(data[i].utype)){
							txt += 1;								 								
							}														
						}
					}				
				$("#totalrigster").html(txt+'位');
				console.log(txt);						
			});
	</script>
</body>
</html>