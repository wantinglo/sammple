<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>userMenu</title>
<!-- JQuery -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<!-- /彈跳視窗 -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

<script
  src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous">
</script>

<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<!-- 彈跳視窗/ -->
<style>
.menu_Style {
	height: 1000px;
	width: 300px;
	float: left;
	margin-left: 20px
}

.menu_headStyle {
	margin: 30px 0px 30px 60px;
}
</style>
</head>
<body>
	<div id="update-menu" class="menu_Style">
		<div id="menu-head" class="menu_headStyle">
			<div id="img">
				<!-- 點擊圖片跳出彈跳視窗 -->
				<label data-toggle="modal" data-target="#exampleModalCenter">
					<img src="data:image/jpeg;base64,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"
					style="cursor: pointer; width: 150px; height: 150px">
				</label>


				<!-- Modal 彈跳視窗內容-->
				<div class="modal fade" id="exampleModalCenter" tabindex="-1"
					role="dialog" aria-labelledby="exampleModalCenterTitle"
					aria-hidden="true">
					<div class="modal-dialog modal-lg" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLongTitle">
									<input type="file" multiple id="picture">
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
								<button type="button" class="btn btn-secondary"
									onclick="upload()">上傳頭像</button>
							</div>
						</div>
					</div>
				</div>
				<script type="text/javascript">
					//點擊上傳
					function upload() {
						//js接收文件
						var formData = new FormData();
						formData.append("files", $("#picture")[0].files[0]);

						$
								.ajax({
									url : "http://localhost:8080/FinalProject/upload.action",
									type : "POST",
									data : formData,
									contentType : false,
									processData : false,//有必要，不然不行
									mimeType : "multipart/form-data",
									success : function() {
										window.location.reload("update.jsp")
									}
								})
					}

					//用來顯示預覽圖片
					//imgInp(file的ID)
					$("#picture").change(function() {
						//當檔案改變後，做一些事 
						readURL(this); // this代表<input id="imgInp">
					});

					function readURL(input) {
						if (input.files && input.files[0]) {
							var reader = new FileReader();
							reader.onload = function(e) {
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
			<li><span><i class="fa fa-lock"></i></span><a
				href="<c:url value='/forget.return' />">登入與帳號安全</a></li>
			<li><span><i class="fa fa-file"></i></span><a
				href="<c:url value='/ordersBymId' />">查詢訂單</a></li>
		</ul>
	</div>
</body>
</html>