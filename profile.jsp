<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>profile page</title>
<link type = "text/css" rel = "stylesheet" href = "profile.css"> <!-- 스타일시트 -->
</head>
<body onload = "info_load();">
<!-- The core Firebase JS SDK is always required and must be listed first -->
<script src="https://www.gstatic.com/firebasejs/6.1.0/firebase.js"></script>

<!-- TODO: Add SDKs for Firebase products that you want to use
     https://firebase.google.com/docs/web/setup#config-web-app -->
<!-- 사용자가 자신의 정보 관리하는 페이지 -->
<script>
  // Your web app's Firebase configuration
  var firebaseConfig = {
    apiKey: "AIzaSyAWbd_XFP_1oGh9PQi4CgUW2Ut55vcPRD4",
    authDomain: "main-7117d.firebaseapp.com",
    databaseURL: "https://main-7117d.firebaseio.com",
    projectId: "main-7117d",
    storageBucket: "main-7117d.appspot.com",
    messagingSenderId: "71576325027",
    appId: "1:71576325027:web:ee37857805180d33"
  };
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
</script>
<script>
var post_id = "<%=request.getParameter("send_id") %>";
</script>
<p id = "logo">PROFILE</p>
<form id = "info">
<fieldset id = "fieldset1">
<legend align = "center" style = "font-size:25px;"><script>document.write(post_id);</script></legend>
<center>
<br>
<table style = "text-align:center;">
<tr><td>ID</td><td><input type = "text" id = "info_id" readonly></td></tr>
<tr><td>PASSWORD</td><td><input type = "text" id = "info_pw"></td></tr>
<tr><td>NAME</td><td><input type = "text" id = "info_name"></td></tr>
<tr><td>GRADE</td><td><input type = "text" id = "info_grade"></td></tr>
<tr><td>MAJOR</td><td><input type = "text" id = "info_major"></td></tr>
<tr><td>GENDER</td><td><input type = "text" id = "info_gender"></td></tr>
<tr><td>INTEREST</td><td><input type = "text" id = "info_interest"></td></tr>
<tr><td>LAST LOGIN</td><td><input type = "text" id = "info_time"></td></tr>
</table>
</center>
</fieldset>
<br>
<input type = "button" value = "WITHDRAW" onmouseover = "this.style.color = 'crimson'" onmouseout = "this.style.color = 'black'" onclick = "withdraw()">
<input type = "button" value = "MODIFY" onclick = "modify_info()" onmouseover = "this.style.color = 'RoyalBlue'" onmouseout = "this.style.color = 'black'">
</form>
<script>
function info_load() // 정보 로드해오는 함수.
{
	firebase.database().ref('user_data').once('value', function(snapshot){
		snapshot.forEach(function(childSnapshot){
			var tmp = childSnapshot.val();
			var key = childSnapshot.key;
			if(tmp.user_id == post_id)
				{
				document.getElementById("info_id").value = post_id;
				document.getElementById("info_pw").value = tmp.user_pw;
				document.getElementById("info_time").value = tmp.user_time;
				}
		});
	});
	firebase.database().ref('user_profile/' + post_id).once('value', function(snapshot){
		var tmp = snapshot.val();
		document.getElementById("info_name").value = tmp.user_name;
		document.getElementById("info_grade").value = tmp.user_grade;
		document.getElementById("info_major").value = tmp.user_major;
		document.getElementById("info_gender").value = tmp.user_gender;
		document.getElementById("info_interest").value = tmp.user_interest;
				
		
	});
	}
	function withdraw() // 탈퇴 함수.
	{
		//탈퇴할 건지 마지막으로 물어보기.
		var check = confirm("정말 탈퇴를 진행하시겠습니까?");
		if(check != 0) // 탈퇴 진행
			{
			//user_data del
			firebase.database().ref('user_data').once('value', function(snapshot){
				snapshot.forEach(function(childSnapshot){
					var tmp = childSnapshot.val();
					var key = childSnapshot.key;
					if(tmp.user_id == post_id)
						{
						firebase.database().ref('user_data/' + key).remove();
						}
				});
			});
			//user_profile del
			firebase.database().ref('user_profile/' + post_id).remove();
			//user_market/sale del
			firebase.database().ref("user_market/sale").once('value', function(snapshot){
				snapshot.forEach(function(childSnapshot){
					var tmp = childSnapshot.val();
					if(tmp.user_id == post_id)
						{
						var key = childSnapshot.key;
						firebase.database().ref("user_market/sale/" + key).remove();
						}
				});
			});
			// marketboard delete.
			firebase.database().ref("user_market/marketboard").once('value', function(snapshot){
				snapshot.forEach(function(childSnapshot){
					var tmp = childSnapshot.val();
					var key = childSnapshot.key;
					
					if(tmp.user_id == post_id)
						{
						firebase.database().ref('user_market/marketboard/' + key).remove();
						}
					});
			});
			//game
			firebase.database().ref("user_game/" + post_id).remove();
			//purchase
			firebase.database().ref('user_market/purchase/' + post_id).remove();
			alert("탈퇴되었습니다.");
			location.href = "main.jsp"; // 메인 화면으로 이동.
			}
		
	
	}
	function modify_info() // 정보 수정 함수.
	{
		var mod_pw = document.getElementById("info_pw").value;
		var mod_name = document.getElementById("info_name").value;
		var mod_grade = document.getElementById("info_grade").value;
		var mod_major = document.getElementById("info_major").value;
		var mod_gender = document.getElementById("info_gender").value;
		var mod_interest = document.getElementById("info_interest").value;
		var mod_time = document.getElementById("info_time").value;
		
		firebase.database().ref('user_data').once('value', function(snapshot){
			snapshot.forEach(function(childSnapshot){
				var tmp = childSnapshot.val();
				if(tmp.user_id == post_id)
					{
					var key = childSnapshot.key;
					firebase.database().ref('user_data/' + key).set({
						user_id:post_id,
						user_pw:mod_pw,
						user_time:mod_time,
					});
					}
			});
		});
		firebase.database().ref('user_profile/' + post_id).set({
			user_gender:mod_gender,
			user_grade:mod_grade,
			user_id:post_id,
			user_interest:mod_interest,
			user_major:mod_major,
			user_name:mod_name,
		});
		alert("수정이 완료되었습니다.");
		var back_check = confirm("이전 페이지로 돌아가시겠습니까?");
		if(back_check != 0)
			{
			history.back();
			}
		
	}
</script>
</body>
</html>