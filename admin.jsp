<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>admin page</title>
<link type = "text/css" rel = "stylesheet" href = "admin.css"> 
</head>
<body>
<!-- The core Firebase JS SDK is always required and must be listed first -->
<script src="https://www.gstatic.com/firebasejs/6.0.2/firebase.js"></script>
<!-- TODO: Add SDKs for Firebase products that you want to use
     https://firebase.google.com/docs/web/setup#config-web-app -->
<!-- 관리자 페이지(회원정보, 마켓정보를 관리하는 페이지) -->
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
function del_post(time,text) //게시글 삭제하는 함수.
{
	alert(time + " : " + text);
	
	var table2 = document.getElementById("board_table");
	
	for(var i = 1; i < table2.rows.length; i++)//표부터 삭제.
		{
		
		if((table2.rows[i].cells[0].innerHTML == time) && (table2.rows[i].cells[1].innerHTML == text))
			{
			table2.deleteRow(i);
			}
		}
	
	firebase.database().ref('user_market/marketboard').once('value', function(snapshot){
		snapshot.forEach(function(childSnapshot){
			var tmp = childSnapshot.val();
			var key = childSnapshot.key;
			if((tmp.post_time == time) && (tmp.user_text == text))
				{
				firebase.database().ref("user_market/marketboard/" + key).remove();
				alert("삭제가 완료되었습니다.");
				}
		});
	});
	}
	function del_sale_info(name) // 판매 정보 삭제하는 함수.
	{
		firebase.database().ref("user_market/sale").once('value', function(snapshot){
			snapshot.forEach(function(childSnapshot){
				var tmp = childSnapshot.val();
				var key = childSnapshot.key;
				if(tmp.item_name == name)
					{
					//표 삭제.
					var table1 = document.getElementById('sale_table');
					for(var i = 1; i < table1.rows.length; i++)
						{
						if(table1.rows[i].cells[0].innerHTML == name)
							{
							table1.deleteRow(i);
							}
						}
					//데이터베이스 삭제.
					firebase.database().ref('user_market/sale/' + key).remove();
					alert(name + "의 삭제가 완료되었습니다.");
					}
			});
		});
		
	}
	function del_p_info(name,id) // 구매 정보 삭제하는 함수.
	{
		firebase.database().ref("user_market/purchase/" + id).once('value', function(snapshot){
			snapshot.forEach(function(childSnapshot){
				var tmp = childSnapshot.val();
				if(tmp.item_name == name)
					{
					//표 삭제
					var table = document.getElementById("purchase_table");
					for(var i = 1; i < table.rows.length; i++)
						{
						if(table.rows[i].cells[0].innerHTML == name)
							{
							table.deleteRow(i);
							}
						}
					
					//데이터베이스 삭제
					firebase.database().ref('user_market/purchase/' + id + "/" + name).remove();
					alert(name + "의 삭제가 완료되었습니다.");
					}
			});
		});
		
	}
</script>
<p id = "logo">ADMIN PAGE</p>
<div id = "leftframe">
<h2>INFORMATION</h2>
<center>
<table id="infotable" border=1>
<tr>
<td>ID</td>
<td>이름</td>
<td>학년</td>
<td>전공</td>
<td>성별</td>
<td>관심사</td>
<td>접속시간</td>
<td>관리</td>
</tr>
</table>
</center>
<br>
<h2>PRIVACY</h2>
<div id = "info">
<br>
<form id = "info_form">
<center>
<table style = "text-align:center;">
<tr><td>
ID</td><td><input type = "text" id = "info_id" readonly>
</td></tr>
<tr><td>
PASSWORD</td><td><input type = "text" id = "info_pw">
</td></tr>
<tr><td>NAME</td><td><input type = "text" id = "info_name"></td></tr>
<tr><td>GRADE</td><td><input type = "text" id = "info_grade"></td></tr>
<tr><td>MAJOR</td><td><input type = "text" id = "info_major"></td></tr>
<tr><td>GENDER</td><td><input type = "text" id = "info_gender"></td></tr>
<tr><td>INTEREST</td><td><input type = "text" id = "info_interest"></td></tr>
<tr><td>LAST LOGIN</td><td><input type = "text" id = "info_time"></td></tr>
</table>
</center><br>
<input type = "button" value = "MODIFY" onclick = "modify_info()">
</form>
</div>
</div>
<div id = "rightframe">
<p id = "logo2">MODIFY</p>

<h2>POST</h2>
<div id = "board">
<center>
<table id = "board_table" border = "1">
<tr><td>post time</td><td>text</td><td>del</td></tr>
</table>
</center>
</div>
<br>
<h2>SALE/PURCHASE</h2>
<div id = "market_info">
<div id = "sale_box">
<center>
<table id = "sale_table" border = "1">
<tr><td>제품명</td><td>가격</td><td>수량</td><td></td></tr>
</table>
</center>
</div>
<div id = "purchase_box">
<center>
<table id = "purchase_table" border = "1">
<tr><td>제품명</td><td>수량</td><td>판매자</td><td></td></tr>
</table>
</center>
</div>
</div>
</div>

<script>
allUserdata();	
	
function del_click(id){ // 삭제 함수.
	
	alert("id:"+ id);
	firebase.database().ref('/user_data').once('value', function(snapshot){ //user_data
		snapshot.forEach(function(childSnapshot){
			var tmp = childSnapshot.val();
			if(tmp.user_id == id)
				{
				var key = childSnapshot.key; // 자동 키 값 모르기 때문에 가져오는 법!
				
				firebase.database().ref('/user_data/' + key).remove();
				}
				});
		});
	
	var user_prof = firebase.database().ref('user_profile/'+id); //user_profile
	user_prof.remove();
	var user_game = firebase.database().ref('user_game/'+id);
	user_game.remove();
	//market 부분 삭제 구현하기!
	firebase.database().ref('/user_market/sale').once('value', function(snapshot){ //sale
		snapshot.forEach(function(childSnapshot){
			var tmp = childSnapshot.val();
			if(tmp.user_id == id)
				{
				var key = childSnapshot.key; // 자동 키 값 모르기 때문에 가져오는 법!
				
				firebase.database().ref('/user_market/sale/' + key).remove();
				}
				});
		});
	// marketboard delete.
	firebase.database().ref("user_market/marketboard").once('value', function(snapshot){
		snapshot.forEach(function(childSnapshot){
			var tmp = childSnapshot.val();
			var key = childSnapshot.key;
			
			if(tmp.user_id == id)
				{
				firebase.database().ref('user_market/marketboard/' + key).remove();
				}
			});
	});
	//purchase
	firebase.database().ref('user_market/purchase/' + id).remove();
	//표 삭제 구현
	var table1_del = document.getElementById("infotable");
	for(var i = 1; i < table1_del.rows.length; i++)
		{
		
		if(table1_del.rows[i].cells[0].innerHTML == id)
			{
			
			table1_del.deleteRow(i);
			}
		}
	//나머지 페이지에 띄워져있는 것들 삭제.
	var table_b = document.getElementById("board_table");
	for(var i = 1; i < table_b.rows.length; i++)
		{
		table_b.deleteRow(1);
		}
	var table_s = document.getElementById("sale_table");
	for(var i = 1; i < table_s.rows.length; i++)
		{
		table_s.deleteRow(1);
		}
	var table_p = document.getElementById("purchase_table");
	for(var i = 1; i < table_p.rows.length; i++)
		{
		table_p.deleteRow(1);
		}
	document.getElementById("info_id").value = '';
	document.getElementById("info_pw").value = '';
	document.getElementById("info_name").value = '';
	document.getElementById("info_grade").value = '';
	document.getElementById("info_major").value = '';
	document.getElementById("info_gender").value = '';
	document.getElementById("info_interest").value = '';
	document.getElementById("info_time").value = '';
	
	alert("삭제되었습니다.");

}
 	
function mod_click(id) //정보들 수정 칸에 띄우는 함수.
{
	firebase.database().ref("user_data").once('value', function(snapshot){ //user_data에서 불러올 정보
		snapshot.forEach(function(childSnapshot){
			var key = childSnapshot.key;
			var tmp = childSnapshot.val();
			if(tmp.user_id == id)
				{
				document.getElementById("info_id").value = tmp.user_id;
				document.getElementById("info_pw").value = tmp.user_pw;
				document.getElementById("info_time").value = tmp.user_time;
				}
		});
	});
	firebase.database().ref("user_profile/" + id).once('value', function(snapshot){ //user_profile
		var tmp1 = snapshot.val();
		document.getElementById("info_name").value = tmp1.user_name;
		document.getElementById("info_gender").value = tmp1.user_gender;
		document.getElementById("info_grade").value = tmp1.user_grade;
		document.getElementById("info_interest").value = tmp1.user_interest;
		document.getElementById("info_major").value = tmp1.user_major;
		
	});
	//게시글 읽어온다.
	//읽어오기 전에 기존에 있던 노드 삭제하기.	
	var table1 = document.getElementById("board_table");
	
	var rows = table1.rows.length;
	for(var i = 1; i < rows; i++)
		{
		
		table1.deleteRow(1); // 지워지면 계속 앞으로 떙겨지므로
		}
	
	
		
		firebase.database().ref("user_market/marketboard").once('value', function(snapshot){
			snapshot.forEach(function(childSnapshot){
				var tmp = childSnapshot.val();
				if(tmp.user_id == id) // 해당 아이디가 올린 글이라면.
					{
					if(document.createElement) // 표에 추가.
						{
						var new_tr = document.createElement("tr");
						new_tr.setAttribute("id", id);
						
						var td_time = document.createElement("td");
						td_time.innerHTML = tmp.post_time;
						new_tr.appendChild(td_time);
						
						var td_text = document.createElement("td");
						td_text.innerHTML = tmp.user_text;
						new_tr.appendChild(td_text);
						
						var del_btn = document.createElement("input");
						del_btn.setAttribute("type", "button");
						del_btn.setAttribute("value", "DEL");
						//삭제 함수 추가하기.
						var del_str = "del_post('" + tmp.post_time + "','" + tmp.user_text + "')";
						
						del_btn.setAttribute("onclick", del_str);
						new_tr.appendChild(del_btn);
						
						table1.appendChild(new_tr);
						}
					}
			});
		});
		
	// sale/purchase
	// 기존에 있던 노드들 삭제.
	var table_s = document.getElementById('sale_table');
	var table_p = document.getElementById("purchase_table");
	var row_s = table_s.rows.length;
	var row_p = table_p.rows.length;
	
	for(var i = 1; i < row_s; i++)
		{
		
		table_s.deleteRow(1);
		}
	for(var i = 1; i < row_p; i++)
	{
	table_p.deleteRow(1);
	}
	//삭제 완료.
	firebase.database().ref("user_market/sale").once('value', function(snapshot){ //sale
		snapshot.forEach(function(childSnapshot){
			var key = childSnapshot.key;
			var tmp = childSnapshot.val();
			if(tmp.user_id == id)
				{
				if(document.createElement)
					{
					var new_tr = document.createElement("tr");
					
					var td_name = document.createElement("td");
					td_name.innerHTML = tmp.item_name;
					new_tr.appendChild(td_name);
					
					var td_price = document.createElement("td");
					td_price.innerHTML = tmp.item_price;
					new_tr.appendChild(td_price);
					
					var td_quantity = document.createElement("td");
					td_quantity.innerHTML = tmp.item_quantity;
					new_tr.appendChild(td_quantity);
					
					var del_btn = document.createElement("input");
					del_btn.setAttribute("type", "button");
					del_btn.setAttribute("value", "DEL");
					var str_s = "del_sale_info('" + tmp.item_name + "')";
					del_btn.setAttribute("onclick", str_s);
					
					new_tr.appendChild(del_btn);
					
					table_s.appendChild(new_tr);
					}
				}
			
		});
	});
	//purchase.
	firebase.database().ref("user_market/purchase/" + id).once('value', function(snapshot){
		snapshot.forEach(function(childSnapshot){
			var tmp = childSnapshot.val();
			var key = childSnapshot.key;
			if(document.createElement)
			{
			var new_tr = document.createElement("tr");
			
			var td_name = document.createElement("td");
			td_name.innerHTML = tmp.item_name;
			new_tr.appendChild(td_name);
			
			var td_quantity = document.createElement("td");
			td_quantity.innerHTML = tmp.item_quantity;
			new_tr.appendChild(td_quantity);
			
			var td_saler = document.createElement("td");
			td_saler.innerHTML = tmp.saler_name;
			new_tr.appendChild(td_saler);
			
			var del_btn = document.createElement("input");
			del_btn.setAttribute("type", "button");
			del_btn.setAttribute("value", "DEL");
			
			var str_p = "del_p_info('" + tmp.item_name + "','" + id + "')";
			//삭제 함수 추가
			
			del_btn.setAttribute("onclick", str_p);
			new_tr.appendChild(del_btn);
			
			table_p.appendChild(new_tr);
			}
		});
		
		
	});
	
	
	
	}

function allUserdata(){
	var user_data = firebase.database().ref('user_data');
	user_data.once('value', function(snapshot) {
	    snapshot.forEach(function(childSnapshot) {
	      var tmp = childSnapshot.val();
	      allUserProfile(tmp.user_id, tmp.user_time);
	      
	    });
	  });
}
function allUserProfile(id, time){
	var table = document.getElementById("infotable");
	var user_data = firebase.database().ref('user_profile/'+id);
	user_data.once('value', function(snapshot) {
	      var tmp = snapshot.val();
	      
	      var new_tr = document.createElement("tr");
	      
	      var td_id = document.createElement("td");
	      td_id.innerHTML = id;
	      new_tr.appendChild(td_id);
	      
	      var td_name = document.createElement("td");
	      td_name.innerHTML = tmp.user_name;
	      new_tr.appendChild(td_name);
	      
	      var td_grade = document.createElement("td");
	      td_grade.innerHTML = tmp.user_grade;
	      new_tr.appendChild(td_grade);

	      var td_major = document.createElement("td");
	      td_major.innerHTML = tmp.user_major;
	      new_tr.appendChild(td_major);

	      var td_sex = document.createElement("td");
	      td_sex.innerHTML = tmp.user_gender;
	      new_tr.appendChild(td_sex);
	      
	      var td_h = document.createElement("td");
	      td_h.innerHTML = tmp.user_interest;
	      new_tr.appendChild(td_h);
	      
	      var td_time = document.createElement("td");
	      td_time.innerHTML = time;
	      new_tr.appendChild(td_time);
	      
	      var str = "del_click('" + id + "')"; //***따옴표 옆에 붙어야 실행***
	      var str2 = "mod_click('" + id + "')";
	     
	      var mod_btn = document.createElement("input");
	      mod_btn.setAttribute("type", "button");
	      mod_btn.setAttribute("value", "수정");
	      mod_btn.setAttribute("onclick", str2);
	      new_tr.appendChild(mod_btn);
	      
	      var del_btn = document.createElement("input");
	      del_btn.setAttribute("type", "button");
	      del_btn.setAttribute("value", "삭제");
	      del_btn.setAttribute("onclick", str);    
	      
	      new_tr.appendChild(del_btn); 
	      
	     
	      
	      table.appendChild(new_tr);
	  });
}
function modify_info() // 회원정보 수정하는 함수.
{
	var mod_id = document.getElementById("info_id").value;
	var mod_pw = document.getElementById("info_pw").value;
	var mod_name = document.getElementById("info_name").value;
	var mod_grade = document.getElementById("info_grade").value;
	var mod_major = document.getElementById("info_major").value;
	var mod_gender = document.getElementById("info_gender").value;
	var mod_interest = document.getElementById("info_interest").value;
	var mod_time = document.getElementById("info_time").value;
	alert(mod_id + " " + mod_pw + " " + mod_name + " " + mod_grade + " " + mod_major + " " + mod_gender + " " + mod_interest + " " + mod_time);
	firebase.database().ref('user_data').once("value", function(snapshot){ //user_data 수정
		snapshot.forEach(function(childSnapshot){
			var key = childSnapshot.key;
			var tmp = childSnapshot.val();
			if(mod_id == tmp.user_id)
				{
				firebase.database().ref("user_data/" + key).set({
					user_id:mod_id,
					user_pw:mod_pw,
					user_time:mod_time,
				});
				}
		});
	});
	firebase.database().ref('user_profile').once("value", function(snapshot){ //user_profile 수정
		snapshot.forEach(function(childSnapshot){
			var key = childSnapshot.key;
			var tmp = childSnapshot.val();
			if(mod_id == tmp.user_id)
				{
				firebase.database().ref("user_profile/" + mod_id).set({
					user_id:mod_id,
					user_gender:mod_gender,
					user_grade:mod_grade,
					user_interest:mod_interest,
					user_major:mod_major,
					user_name:mod_name,
				});
				}
		});
	});
	alert("수정이 완료되었습니다.");
	}
	
</script>
</body>
</html>