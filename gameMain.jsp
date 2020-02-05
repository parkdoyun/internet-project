<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Game Main Page</title>
<style>
#leftframe{
width:75%;
text-align:center;
float:left;
height:1000px;
border-right:1.5px solid;
}
#rightframe{
width:24%;

float:right;
height:1000px;

}
#gameboard1{
        background-color:MediumSeaGreen;
        width : 500px;
        height : 300px;
        }
    #user1{
        float:left;
        width : 200px;
        height : 200px;
    }
    #com1{
        float:right;
        width : 200px;
        height : 200px;
    }
</style>
</head>
<body onload = "nowTime()">
<!-- The core Firebase JS SDK is always required and must be listed first -->
<!-- 시범 삼아 추가로 만들어봤던 게임 페이지 -->
<script src="https://www.gstatic.com/firebasejs/6.0.2/firebase.js"></script>
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
function checkTextLength(obj) //글자수 제한 함수.
{
	var str = obj.value;
	var str_len = str.length;
	var maxByte = 200;
	var one_char = '';
	var rbyte = 0;
	var rlen = 0;
	var str2 = "";
	for(var i = 0; i < str_len; i++)
		{
		one_char = str.charAt(i);
		if(escape(one_char).length > 4)
			{
			rbyte += 2;
			}
		else
			{
			rbyte++;
			}
		if(rbyte <= maxByte)
			{
			rlen = i + 1;
			}
		}
	if(rbyte > maxByte)
		{
		alert("텍스트는 최대 " + maxByte/2 + "까지 입력 가능합니다.");
		str2 = str.substr(0, rlen);
		obj.value = str2;
		}
	
	}
	
function nowTime()
{
	var time = new Date();
	var time_str = time.toLocaleTimeString();
	var str = time_str;
	document.getElementById('time1').innerText = str;
}
	
	var input_text;//게시판에 넣을 text node.
	var user_game = firebase.database().ref("user_game");
	var data = new Array();
	user_game.on('value', function(snapshot) {
	    data.splice(0, data.length);
	    snapshot.forEach(function(childSnapshot) {
	      var childData = childSnapshot.val();
	      data.push(childData.user_id);
	    });
	  });
	var user_id = "<%=request.getParameter("send_id") %>";
	firebase.database().ref('user_game/' + user_id + '/user_id').set( //database에 게시글 넣기!
			  user_id
		  );
function postText() // 게시판에 게시, database에 글 push하는 함수.
{
	var time = new Date();
	var time_str = time.toLocaleTimeString();
	var year = time.getFullYear();
	var month = time.getMonth();
	month++;
	var date = time.getDate();
	var total_time_str = time_str + ' ' + year + '-' + month + '-' + date; // ex) 오전 2:58:3 2019-05-23
	var text = document.getElementById('board_input').value;
	var total_str = "<%=request.getParameter("send_id") %>" + ' ' + total_time_str + '\n' + text;
	
	if(document.createElement) // node로 넣는 객체
		{
		input_text = document.createElement("div");
		input_text.innerText = total_str;
		var par = document.getElementById("board_main");
		par.appendChild(input_text);
		}
	
	firebase.database().ref('user_game/' + user_id + '/gameboard/' + total_time_str).set( //database에 게시글 넣기!
		  text
	  );
	
	document.getElementById('board_input').value = ""; // 게시 후 입력 텍스트 창 비우기.
	alert("게시되었습니다.");
	}
	function logout()
	{
		location.href = "main.jsp";
		alert("로그아웃되었습니다.");
	}
</script>
<script>
var com1_count;
var user1_count;
var user1_score = 0;
var user1_game_count = 0;
function user1_sci()
{
    user1_count = 1;
    document.getElementById("user1_img").src = "media/scissor.png";

}
function user1_rock()
{
    user1_count = 2;
    document.getElementById("user1_img").src = "media/rock.png";
}
function user1_paper()
{
    user1_count = 3;
    document.getElementById("user1_img").src = "media/paper.png";
}
function game1_start()
{
    com1_count = Math.floor(Math.random() * 3) + 1; // 1부터 3까지 난수 생성
    var img = document.getElementById("com1_img");
    if(user1_game_count > 9)
    {
        alert("10번 시도하였습니다. 자동으로 점수가 저장됩니다.");
        game1_score_set();
        return;
    }
    user1_game_count++;
    if(com1_count == 1)
    {
        
        img.src = "media/scissor.png";
        img.onload = function () 
            {
                if(user1_count == 1)
        {
            alert("비겼습니다.");
            user1_score += 5;
            show_score1();

        }
        else if(user1_count == 3)
        {
            alert("졌습니다.");
            user1_score -= 5;
            show_score1();
            
        }
        else{
            alert("이겼습니다!");
            user1_score += 10;
            show_score1();
        }
            };
        
        
    }
    else if(com1_count == 2)
    {
        document.getElementById("com1_img").src = "media/rock.png";
        img.onload = function(){
            if(user1_count == 2)
        {
            alert("비겼습니다.");
            user1_score += 5;
            show_score1();

        }
        else if(user1_count == 1)
        {
            alert("졌습니다.");
            user1_score -= 5;
            show_score1();
            
        }
        else{
            alert("이겼습니다!");
            user1_score += 10;
            show_score1();
        }
        };
        
        
    }
    else{
        document.getElementById("com1_img").src = "media/paper.png";
        img.onload = function()
        {
            if(user1_count == 3)
        {
            alert("비겼습니다.");
            user1_score += 5;
            show_score1();
            

        }
        else if(user1_count == 2)
        {
            alert("졌습니다.");
            user1_score -= 5;
            show_score1();
            
        }
        else{
            alert("이겼습니다!");
            user1_score += 10;
            show_score1();
        }
        };
        
        
    }
    
}
function show_score1()
{
    document.getElementById("score1_show").innerHTML = user1_score;
}
function game1_score_set()
{
	var score = document.getElementById("score1_show").innerHTML;
	firebase.database().ref('user_game/' + user_id + '/game1').set( //database에 게시글 넣기!
			  score
		  );
	
	}
</script>
<div id = "leftframe">
<p style = "border-bottom:1.5px solid;text-align:justify;">
<span id = "id" style = "font-size:26px;">
<%=request.getParameter("send_id") %></span>님 안녕하세요! <input type = "button" value = "LOGOUT" onclick = "logout()">
<span style = "float:right;margin-right:9px;font-size:20px;" id = "time1"></span>
</p>

<script>
setInterval("nowTime()", 1000);
</script>
<br>
<p style = "text-align:center;width:30%;margin-left:35%;border-bottom:1.5px solid;">
<span style = "text-align:center;font-size:40px;">GAME</span></p><br><br>
<div style = "margin-left:30px;float:left;width:500px;height:400px;border:1px solid;background-color:Olive;">
<div id = "gameboard1">
<div id = 'user1'>
<img src = "media/no_image.png" width = "200" height = "200" id = "user1_img">
</div>
<div id = 'com1'>
        <img src = "media/no_image.png" width = "200" height = "200" id = "com1_img">
    </div>
    </div>
    <input type = "button" value = "가위" onclick = "user1_sci()">
    <input type = "button" value = "바위" onclick = "user1_rock()">
    <input type = "button" value = "보" onclick = "user1_paper()">
    <br>
    
    <input type = "button" value = "시작" onclick = "game1_start()">
    <input type = "button" value = "완료" onclick = "game1_score_set()">
    <p id = "score1_show">0</p>
</div>
<div style = "margin-left:50px;float:left;width:500px;height:400px;border:1px solid;">
<p style = "border:1px solid;width:500px;height:300px;">게임2 canvas가 들어갈 자리입니다.</p>
<h2>SCORE : 2300</h2></div>

</div>

<div id = "rightframe">
<p style = "width:90%;font-size:35px;border-bottom:1.5px solid;text-align:center;margin-left:5%;" id = "board_logo">BOARD</p>
<div id = "board_main" style = "border:1.5px solid;background-color:white;width:90%;height:700px;margin-left:5%;"></div><br>
<form>
<textarea  onKeyUp = "checkTextLength(this)" id = "board_input" name = "board_input" style = "width:88%;margin-left:5%;height:100px;">텍스트를 입력해주세요.(100자까지 입력 가능)</textarea><br>
<center><input type = "button" value = "POST" onclick = "postText()"></center> <!-- <center>태그 쓰면 가운데 정렬! -->
</form>

</div>

</body>
</html>