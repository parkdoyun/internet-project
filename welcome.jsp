<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<base href="<%=basePath%>">
<title>welcome!</title>
<style>
#logo{
width:100%;
font-size:40px;

margin-left:50px;
}
#leftside{
float:left;
width:50%;
border-top:2px solid;
height:350px;
}
#userInfo{
text-align:center;
padding-left:50px;
padding-right:50px;
margin-top:10px;
}
#rightside{
height:350px;
float:right;
border-top:2px solid;
width:50%;
}
#c{
margin-top:70px;
margin-left:100px;

}
#downside1{
clear:both;
width:100%;
text-align:center;
}
#post_id{
margin-top:30px;
padding-left:50px;
font-size:23px;

}
</style>
<script>
function drawClock() // 시계
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
    context.strokeStyle = "SteelBlue";
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
<!-- 처음 로그인하고 볼 수 있는, 마켓페이지로 넘어가기 전의 페이지 -->
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
<%String time = (String) session.getAttribute("time");%>
<%String id = (String) session.getAttribute("id");%>
var post_id = "<%=id %>"; // 넘어온 아이디 변수 
var post_time = "<%=time%>";


//보기에는 이상해도 이렇게 해야 submit으로 넘어온 변수가 들어간다(문자열 형식으로).
//var str = string;(x) / var str = "string";(O) -> 이거랑 같은 소리.
function loadInfo()
{
	
	firebase.database().ref('user_profile/' + post_id).on('value', function(snapshot){
		
		var tmp = snapshot.val();
		
		document.getElementById("name").value = tmp.user_name;
		document.getElementById("gender").value = tmp.user_gender;
		document.getElementById("grade").value = tmp.user_grade;
		document.getElementById("major").value = tmp.user_major;
		document.getElementById("interest").value = tmp.user_interest;
		document.getElementById("login_time").value = post_time;
		
		
	
});
}

function timeSet() // 이렇게 해서 <body onload = "timeSet()">해도 다시 시간이 현재 로그인 시간으로 바뀌어버림!(시간 바뀌면 동적으로 다시 시간 변경됨. 로그인 페이지에서 데이터 넘겨주기!)
{
	var time = new Date();
	var hour = time.getHours();
	var min = time.getMinutes();
	var sec = time.getSeconds();
	var time_str = hour + ':' + min + ":" + sec;
	var year = time.getFullYear();
	var month = time.getMonth();
	month++;
	var date = time.getDate();
	var total_time_str = time_str + ' ' + year + '-' + month + '-' + date; // ex) 오전 2:58:3 2019-05-23
	
	firebase.database().ref('/user_data').once('value', function(snapshot){
		snapshot.forEach(function(childSnapshot){
			var tmp = childSnapshot.val();
			if(tmp.user_id == post_id)
				{
				var key = childSnapshot.key; // 자동 키 값 모르기 때문에 가져오는 법!
				
				firebase.database().ref('/user_data/' + key+ '/user_time').set(total_time_str);
				}
				});
		});
	
	}


/*
  또는 
  firebase.database().ref('user_profile/' + post_id + '/user_time').set( //update말고 set하면 모든 데이터가 다 지워지고 다시 쓰여진다!
		time_str
	); -> 이렇게 쓸 수도 있다.
 
 */
 
 function goGame() // 각각의 버튼마다 이동하는 페이지 다름 -> action page 따로 지정해줘야함.
	{
		document.getElementById("datasend").action = "gameMain.jsp"; // 일단 함수 들어와야 하므로 type을 button으로 지정해준 뒤 
		document.getElementById("datasend").submit();			 	 // action page 지정 후 form을 submit한다!
	}
function goMarket()
{
	var form = document.getElementById("datasend");
	var id = document.getElementById("send_id").value;
	form.setAttribute("action", "./MarketServlet?id=" + id + '');
	form.submit();
	
	}
function go_profile() //정보 관리 페이지로 넘어가기.
{
	var input_pw = prompt(post_id + "님의 비밀번호를 입력해주세요.");
	firebase.database().ref("user_data").once('value', function(snapshot){
		snapshot.forEach(function(childSnapshot){
			var tmp = childSnapshot.val();
			if(tmp.user_id == post_id)
				{
				if(tmp.user_pw == input_pw)//맞는 비밀번호를 입력했을 시!
					{
					alert("회원정보 관리페이지로 이동합니다.");
					var form = document.getElementById("datasend"); // 그냥 폼으로 전송.
					form.setAttribute("action", "profile.jsp");
					form.submit();
					}
				else
					{
					alert("비밀번호가 올바르지 않습니다.");
					}
				}
		});
	});
	
	}
	
function go_logout() // 로그아웃 함수
{
	location.href = "main.jsp";
	alert("로그아웃되었습니다.");
	
	}
</script>

<p id = "logo">WELCOME!</p>
<div id = "leftside">
<br><!-- 서블릿으로 받아온 아이디. -->
<span id = "post_id"><%=id %></span>님 환영합니다! <input type = "button" value = "INFO" onmouseover = "this.style.color = 'Olive'" onmouseout = "this.style.color = 'black'" onclick = "go_profile()">
<input type = "button" value = "LOGOUT" onmouseover = "this.style.color = 'crimson'" onmouseout = "this.style.color = 'black'" onclick = "go_logout()">

<form id = "userInfo">
<fieldset>
<legend>INFORMATION</legend>
<table>
<tr>
<td>NAME</td><td><input type = "text" id = "name"></td>
</tr>
<tr>
<td>GENDER</td><td><input type = "text" id = "gender"></td>
</tr>
<tr>
<td>GRADE</td><td><input type = "text" id = "grade"></td>
</tr>
<tr>
<td>MAJOR</td><td><input type = "text" id = "major"></td>
</tr>
<tr>
<td>INTEREST</td><td><input type = "text" id = "interest"></td>
</tr>
<tr>
<td>LAST LOGIN</td><td><input type = "text" id = "login_time"></td>
</tr>
</table>
</fieldset>
</form>
</div>
<div id = "rightside">
<canvas id = "c" height = "200" width = "200"></canvas>
</div>

<div id = "downside1">
<form id = "datasend" method = "POST">
<input type = "button" value = "GAME" id = "game_button" onclick = "goGame()"
 onmouseover = "this.style.color = 'SteelBlue'" onmouseout = "this.style.color = 'black'">
<input type = "button" value = "MARKET" id = "market_button" onclick = "goMarket()"
 onmouseover = "this.style.color = 'SteelBlue'" onmouseout = "this.style.color = 'black'"><br>
<input style = "visibility:hidden;" type = "text" id = "send_id" name = "send_id" value = "<%=id%>"> <!-- 넘겨줄 아이디 보관 form -->
</form>
</div>


<script>
loadInfo();
timeSet();
</script>
</body>
</html>