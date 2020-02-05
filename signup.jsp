<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>signup page</title>
<style>
div{
width:30%;
margin-left:50%;
}
#logo{
width:500px;
margin-left:-250px;
font-size:40px;
text-align:center;
}
table{

width:400px;
margin-left:-200px;
text-align:center;
}
#border1{ 
margin-top : 65px;
width:500px;
height:295px;
margin-left:-250px;
position:absolute;
z-index:-2;
border:2px solid;
border-style:groove;
}
#signup{
width:100px;

margin-left:-50px;

text-align:center;
}
</style>
</head>
<body>
<!-- The core Firebase JS SDK is always required and must be listed first -->
<script src="https://www.gstatic.com/firebasejs/6.1.0/firebase.js"></script>

<!-- TODO: Add SDKs for Firebase products that you want to use
     https://firebase.google.com/docs/web/setup#config-web-app -->
<!-- 회원가입 페이지 -->
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
var user_profile = firebase.database().ref('user_profile');
var data = new Array();
user_data.on('value', function(snapshot) {
    data.splice(0, data.length);
    snapshot.forEach(function(childSnapshot) {
      var childData = childSnapshot.val();
      data.push(childData.user_id);
    });
  });
user_profile.on('value', function(snapshot) {
    data.splice(0, data.length);
    snapshot.forEach(function(childSnapshot) {
      var childData = childSnapshot.val();
      data.push(childData.user_id);
    });
  });
  
  function signup()
  {
	  //입력 칸 비었는지 확인.
	  var check_id = document.getElementById("id").value;
	  var check_pw = document.getElementById("pw").value;
	  var check_name = document.getElementById("name").value;
	  var check_major = document.getElementById("major").value;
	  var check_interest = document.getElementById("interest").value;
	  if(check_id == '' || check_pw == '' || check_name == '' ||
			  check_major == '' || check_interest == '')
		  {
		  alert("There is a blank space.");
		  return;
		  }
	  
	  var gender_val = ''; //gender 값 가져올 변수
		var gender = document.getElementsByName("gender");
		var gender_check = 0;
		for(var i = 0; i < gender.length; i++)
			{
			
			if(gender[i].checked == true)
				{
				gender_check++;
				gender_val = gender[i].value;
				}
			}
		if(gender_check == 0)//체크되었나 확인.
			{
			alert("gender is not checked.");
			return;
			}
		
		// 학년 값 저장할 변수 grade.
		var select_target = document.getElementById('grade');
		var grade = select_target.options[select_target.selectedIndex].value;
		if(grade == '') // 체크되었나 확인.
			{
			alert("grade is not selected.");
			return;
			}
	  var i = document.getElementById("id").value;
	  var p = document.getElementById("pw").value;
	  var name = document.getElementById("name").value;
	  var major = document.getElementById("major").value;
	  var interest = document.getElementById("interest").value;
	  var time = "No past login history.";
	  if(document.getElementById("id").disabled)
		  {
		  
		  user_data.push({
			  user_id : i,
		  	  user_pw : p, // **매우 중요** ,(콤마) 붙여야 실행됨!
		  	  user_time:time,
		  	  
		  });
		  
		  firebase.database().ref('user_profile/' + i).set({ //이렇게 안 하고 위에처럼 push하면 글씨가 깨진다.
			  user_name : name,
			  user_gender : gender_val,
			  user_grade : grade,
			  user_major : major,
			  user_interest : interest,
			  user_id : i,
			  
			
		  });
		  alert("SIGNUP SUCCESS!");
		  history.back();
		  }
	  else
		  {
		  alert("Doublecheck is needed.");
		  }
  }
  function doubleCheck() // 기존에 있던 forEach 이용해서 하면 안 먹는다. -> 내가 바꿔줌!
  {
	    var id = document.getElementById("id").value;
	    if(id == '')
	    	{
	    	alert("아이디 입력 칸이 비었습니다.");
	    	return;
	    	}
        var checked = 0;
        user_data.once('value', function(snapshot){
    		snapshot.forEach(function(childSnapshot){
    			var tmp = childSnapshot.val();
    			
    			if(tmp.user_id == id){
    				alert("이미 사용중인 아이디입니다");
    	            checked = 1;
    				
    			}
    	
    		});
    		
    	});
        if(checked==0){
          alert("사용 가능한 아이디입니다");
          document.getElementById("id").disabled = true;
        }
      
  }
  


</script>

<div>
<p id = "border1"></p>
<p id = "logo">SIGNUP</p>
<form method = "GET" name = "inputForm">

<table>
<tr><td>
ID</td>
<td><input type = "text" id = "id"></td><td>
<input type = "button" value = "DOUBLE CHECK"  onmouseover = "this.style.color = 'SeaGreen'" onmouseout = "this.style.color = 'black'" onclick = "doubleCheck()">
</td></tr>
<tr>
<td>
PASSWORD</td><td>
<input type = "password" id = "pw">
</td></tr>
<tr>
<td>
NAME</td><td>
<input type = "text" id = "name">
</td></tr>
<tr>
<td>
GENDER</td><td>
<input type = "radio" name = "gender" value = "male">MALE <input type = "radio" name = "gender" value = "female"> FEMALE
</td></tr>
<tr>
<td>
GRADE</td><td>
<select name = "grade" id = "grade">
<option value = "1">1</option>
<option value = "2">2</option>
<option value = "3">3</option>
<option value = "4">4</option>
</select>
</td></tr>
<tr>
<td>
MAJOR</td><td>
<input type = "text" id = "major">
</td></tr>
<tr>
<td>
INTEREST</td><td>
<input type = "text" id = "interest">
</td></tr>
</table>
</form>
<p id = "signup">
<input type = "button" value = "SIGNUP"  onmouseover = "this.style.color = 'SeaGreen'" onmouseout = "this.style.color = 'black'" onclick = "signup()">
</p>
</div>
</body>
</html>