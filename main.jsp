<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login page</title><!-- 로그인 첫 페이지 -->
<style>
#post_time1{visibility:hidden;}
div{
width:30%;
margin-left:50%;

}
#logo{
width:300px;
margin-left:-150px;
border-bottom:1.5px solid;
font-size:40px;
text-align:center;

}
form{
width:300px;
margin-left:-150px;
text-align:center;
}
canvas{
margin-left:-100px;
}
</style>
<script>
//시계
       
        function drawClock()
        {   
            var canvas = document.getElementById("c");
            var context = canvas.getContext("2d");
            
           
            context.beginPath();
            context.lineWidth = 3;
            context.strokeStyle = "black";
            context.arc(100, 100, 80, 0, 2.0 * Math.PI, false);
            
            context.stroke();
            
            
        }
        
        function drawNiddle()
        {
            
            var canvas = document.getElementById("c");
            var context = canvas.getContext("2d");
           
            var today = new Date();
           var hour = today.getHours();
           
            var min = today.getMinutes();
            var sec = today.getSeconds();
            

            context.beginPath();
            context.strokeStyle = "black";
            context.moveTo(100,100);
            if(hour > 12 && hour < 24)
            {
                var h = hour - 12;
                context.lineTo(100 + Math.cos((2.0* Math.PI/12 * h) - Math.PI / 2) * 55, 100 + Math.sin((2.0* Math.PI/12 * h) - Math.PI / 2) * 55 ); //hour niddle
            }
            else if(hour >= 0 && hour <= 12)
            {
                context.lineTo(100 + Math.cos((2.0* Math.PI/12 * hour) - Math.PI / 2) * 55, 100 + Math.sin((2.0* Math.PI/12 * hour) - Math.PI / 2) * 55 ); //hour niddle
            }
            context.stroke();

            context.beginPath();
            context.strokeStyle = "black";
            context.moveTo(100,100);
            context.lineTo(100 + Math.cos((2.0* Math.PI/60 * min)- Math.PI / 2) * 70, 100 + Math.sin((2.0* Math.PI/60 * min)- Math.PI / 2)*70); //min niddle
            context.stroke();

            context.beginPath();
            context.strokeStyle = "MediumPurple";
            context.moveTo(100,100);
            context.lineTo(100 + Math.cos((2.0* Math.PI/60 * sec)- Math.PI / 2)*70, 100 + Math.sin((2.0* Math.PI/60 * sec)- Math.PI / 2)*70); //sec niddle
            context.stroke();
            

        }
        
        function draw()
        {
            var canvas = document.getElementById("c");
            var context = canvas.getContext("2d");
            context.clearRect(0, 0, 200, 200);
            drawClock();
            drawNiddle();
        }
        setInterval("draw()", 1000);
        

</script>
</head>
<body onload = "draw()">
<!-- The core Firebase JS SDK is always required and must be listed first -->
<script src="https://www.gstatic.com/firebasejs/6.1.0/firebase.js"></script>

<!-- TODO: Add SDKs for Firebase products that you want to use
     https://firebase.google.com/docs/web/setup#config-web-app -->

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
var user_data = firebase.database().ref('user_data');
var user_profile = firebase.database().ref('user_profile'); //***까먹지 말고 항상 적을 것***

function goSign()
{
	location.href = "signup.jsp";
	}


	
function mylogin()
{
	var i = document.getElementById("id").value;
	var p = document.getElementById("pw").value;
	
	var check = 0;
	
	
	
	user_data.once('value', function(snapshot){
		snapshot.forEach(function(childSnapshot){
			var tmp = childSnapshot.val(); //user_data의 첫번째 자식 데이터.
			if(tmp.user_id == i){
				if(tmp.user_pw == p)
					{
					alert("login success!");
					check = 1;
					document.getElementById("post_time1").value = tmp.user_time;//user_data에 기록 있으므로 바로 form에 넣는다.
					var form = document.getElementById("form");
					var time = tmp.user_time;
					var id = tmp.user_id;
					form.setAttribute("action", "./LoginServlet?time=" + time + "&&id=" + id + ''); //세션으로 보내기
					form.submit(); //전송
					 // 이렇게 안 하고 애초에 login 버튼을 submit으로 만들면 그냥 누르기만 해도 다음 페이지로 넘어가버림!
					}    									  // 로그인 성공 후에 페이지 넘어가게 하려면 이렇게 만들어야 한다!
				else
					{
					alert("wrong password.");
					check = 1;
					}
				
			}
	
		});
		if(check == 0)
			{
			alert("id is not founded.");
			}
	});
	}

function myAdmin()
{
	var admin_pw = prompt("관리자 비밀번호를 입력하세요.");
	firebase.database().ref('admin_data').once('value', function(snapshot){
		var tmp = snapshot.val();
		if(tmp.admin_pwd == admin_pw)
			{
			alert("관리자 페이지로 이동합니다.");
			location.href = "admin.jsp";
			
			}
		else{
			alert("비밀번호가 틀렸습니다.");
		}
	});
	}

</script>
<br><br>
<div>

<p id = "logo">LOGIN<br></p>
<form id = "form" method = "POST" action = "welcome.jsp"> <!-- submit하면 welcome.jsp로 데이터 전송 -->
<table style = "text-align:center;">
<tr>
<td>ID</td><td><input size = "20px" type = "text" name = "id" id = "id"></td> <!-- 전송되는 데이터는 name으로 구분한다. -->
</tr>
<tr>
<td>PASSWORD</td><td><input size = "20px" type = "password" name = "id" id = "pw"></td>
</tr>

</table>
<br>
<input type = "button" onmouseover = "this.style.color = 'MediumPurple'" onmouseout = "this.style.color = 'black'" onclick = "mylogin()" value = "LOGIN" id = "login"> <!-- submit -->
<input type = "button" onmouseover = "this.style.color = 'SeaGreen'" onmouseout = "this.style.color = 'black'" onclick = "goSign()" value = "SIGNUP" id = "signup"><br><br>
<input type = "button" onmouseover = "this.style.color = 'blue'" onmouseout = "this.style.color = 'black'" onclick = "myAdmin()" value = "ADMIN"><br>
<input type = "text" id = "post_time1" name = "post_time"><!-- css 이용해서 안 보이게 해줌! -->

</form>
<canvas id = "c" width = "200" height = "200">
        </canvas>
</div>
</body>
</html>