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
<title>Market Main Page</title>
<link type = "text/css" rel = "stylesheet" href = "marketMain.css"> <!-- 스타일시트 -->
</head>
<body onload = "nowTime()">
<!-- The core Firebase JS SDK is always required and must be listed first -->
<script src="https://www.gstatic.com/firebasejs/6.1.0/firebase.js"></script>

<!-- TODO: Add SDKs for Firebase products that you want to use
     https://firebase.google.com/docs/web/setup#config-web-app -->
<!-- 마켓 페이지 화면 -->
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

function checkTextLength(obj) // 글자수 제한 함수.
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
	
var input_text;//게시판에 넣을 text node.
var user_market = firebase.database().ref("user_market");
var data = new Array();
user_market.on('value', function(snapshot) {
    data.splice(0, data.length);
    snapshot.forEach(function(childSnapshot) {
      var childData = childSnapshot.val();
      data.push(childData.user_id);
    });
  });
<%String id = (String) session.getAttribute("id");%>
var user_id = "<%=id %>";

function postText() //게시판에 글 올리는 함수.
{
	
	var time = new Date();
	var time_str = time.toLocaleTimeString();
	var year = time.getFullYear();
	var month = time.getMonth();
	month++;
	var date = time.getDate();
	var total_time_str = time_str + ' ' + year + '-' + month + '-' + date; // ex) 오전 2:58:3 2019-05-23
	var text = document.getElementById('board_input').value;
	var total_str = "<%=id %>" + ' ' + total_time_str + '\n' + text;
	
	if(document.createElement) // node로 넣는 객체
		{
		input_text = document.createElement("div");
		input_text.innerText = total_str;
		var par = document.getElementById("board_main");
		par.appendChild(input_text);
		}
	firebase.database().ref('user_market/marketboard').push({
		post_time:total_time_str,
		user_id:user_id,
		user_text:text,
	});
	//firebase.database().ref('user_market/marketboard/' + total_time_str + '/user_id').set(user_id);
	//firebase.database().ref('user_market/marketboard/' + total_time_str + '/user_text').set( //database에 게시글 넣기!
		//	text
	  //);
	
	
	document.getElementById('board_input').value = ""; // 게시 후 입력 텍스트 창 비우기.
	alert("게시되었습니다.");
	}
	
function nowTime()
{
	var time = new Date();
	var time_str = time.toLocaleTimeString();
	var str = time_str;
	document.getElementById('time1').innerText = str;
}
function sale_name_check(n) // 상품 중복확인하는 함수.
{
	var check = 0;
firebase.database().ref("user_market/sale").once('value', function(snapshot){
	snapshot.forEach(function(childSnapshot){
		var tmp = childSnapshot.val();
		
		if(tmp.item_name == n)
			{
			
			alert("중복되는 상품이 이미 존재합니다. (판매자 : " + tmp.user_id + ")");
			check = 1;
			//return; 여기서 안 됨.
			}
		
	});
});	
if(check == 1) // 데이터 읽는 부분에서 바로 리턴 안 된다. 여기서 중복확인 되었는지 검사.
	{ 
	return 1;
	}
return 0;
	}
function sale_start() //판매등록하는 함수! 표에 판매 표시하는 것 구현하기.
{
	var item_name = document.getElementById("sale_item_name").value;
	var price = document.getElementById("sale_item_price").value;
	var quantity = document.getElementById("sale_item_quantity").value;
	if(item_name == '' || price == '' || quantity == '') // 빈칸 존재 시.
		{
		alert("빈 칸이 존재합니다.");
		return;
		}
	if((isNaN(price) == true) || (isNaN(quantity) == true))
	{
	alert("잘못된 수량 또는 가격을 입력하셨습니다.");
	return;
	}
	if(sale_name_check(item_name) == 1)
		{
		
		return;
		}
	
	if(document.createElement) // 판매자 창에 올라가는 표.
		{
		var table = document.getElementById("sale_info_table");
		var new_tr = document.createElement("tr");
		var td_check = document.createElement("input");
		td_check.setAttribute("type", "checkbox");
		td_check.setAttribute("value", item_name);
		td_check.setAttribute("name", "sale_item1");
		new_tr.appendChild(td_check);
		
		
		
		var td_name = document.createElement("td");
		td_name.innerHTML = item_name;
		new_tr.appendChild(td_name);
		
		var td_price = document.createElement("td");
		td_price.innerHTML = price;
		new_tr.appendChild(td_price);
		
		var td_quantity = document.createElement("td");
		td_quantity.innerHTML = quantity;
		new_tr.appendChild(td_quantity);
		
		table.appendChild(new_tr);
		alert("item : " + item_name + " price : " + price + " quantity : " + quantity);
		
		}
	//구매 창에 추가되는 표
	if(document.createElement)
		{
		var table = document.getElementById("purchase_table");
		var new_tr = document.createElement("tr");
		var td_check = document.createElement("input");
		
		td_check.setAttribute("type", "checkbox");
		td_check.setAttribute("value", item_name);
		td_check.setAttribute("name", "purchase_item1");
		new_tr.appendChild(td_check);
		
		var td_name = document.createElement("td");
		td_name.innerHTML = item_name;
		new_tr.appendChild(td_name);
		
		var td_price = document.createElement("td");
		td_price.innerHTML = price;
		new_tr.appendChild(td_price);
		
		var td_quantity = document.createElement("td");
		td_quantity.innerHTML = quantity;
		new_tr.appendChild(td_quantity);
		
		
		var td_saler = document.createElement("td");
		td_saler.innerHTML = user_id;
		new_tr.appendChild(td_saler);
		
		table.appendChild(new_tr);
		
		
		}
	
	firebase.database().ref('user_market/sale').push({
		
		item_name:item_name,
		item_price:price,
		item_quantity:quantity,
		user_id:user_id,
		
	});
	alert("판매 등록이 완료되었습니다.");
	}
	function logout()
	{
		location.href = "main.jsp";
		alert("로그아웃되었습니다.");
	}
	function quantity_check() // 수량 다 된 것 있으면 데이터베이스에서 삭제하는 함수.
	{
		firebase.database().ref('user_market/sale').once('value', function(snapshot){
			snapshot.forEach(function(childSnapshot){
				var tmp = childSnapshot.val();
				if(tmp.item_quantity == 0) // 수량 다 된 것(0개) 있으면 데이터베이스에서 삭제!
					{
					var remove_key = childSnapshot.key;
					firebase.database().ref('user_market/sale/' + remove_key).remove();
					}
			});
		});
		}
	
	
	
	
	function go_purchase() //구매 함수. 
	{
		var user_id = "<%=id%>";
		var table_s = document.getElementById("sale_info_table");
		var tablep = document.getElementById("purchase_table");
		var sale_data = firebase.database().ref('user_market/sale');
		var purchase_data = firebase.database().ref('user_market/purchase');
		var table_check = document.getElementsByName("purchase_item1");//배열로 얻어와서 전체 목록 돌아가면서 체크된 것 수량 하나 빼고 구매 데이터에 올리는 식으로!
		var check_count = 0;
		for(var i = 0; i < table_check.length; i++)
			{
			
			if(table_check[i].checked == true)//체크되었다면
				{
				check_count++;
				sale_data.once('value', function(snapshot){
					snapshot.forEach(function(childSnapshot){
						var tmp = childSnapshot.val();
						
						if(tmp.item_name == table_check[i].value) //데이터베이스에서 탐색
							{
				
							var key = childSnapshot.key;
							var sale_quantity;
							//sale 데이터베이스에서 수량 줄이는 부분
							firebase.database().ref("user_market/sale/" + key).once('value', function(snapshot){ //수량 얻어온다
								var tmp2 = snapshot.val();
								sale_quantity = tmp2.item_quantity;
							});
							sale_quantity--; // 수량 하나 줄인 뒤 다시 set.
							firebase.database().ref("user_market/sale/" + key + "/item_quantity").set(
								sale_quantity
							);
							//판매 표와 구매 창의 표 수량도 바꾼다.
							for(var k = 1; k < table_s.rows.length; k++)
								{
								if(table_s.rows[k].cells[0].innerHTML == tmp.item_name)
									{
									table_s.rows[k].cells[2].innerHTML = sale_quantity;
									}
								}
							for(var k = 1; k < tablep.rows.length; k++)
							{
							if(tablep.rows[k].cells[0].innerHTML == tmp.item_name)
								{
								tablep.rows[k].cells[2].innerHTML = sale_quantity;
								}
							}
							var item_quantity1;
							firebase.database().ref('user_market/purchase/' + user_id + "/" + tmp.item_name).once('value', function(snapshot){
								var tmp1 = snapshot.val();
								item_quantity1 = tmp1.item_quantity;
							});
							
							if(item_quantity1 != null){//처음 구매하는 건지 확인
								item_quantity1++;
							}
							else{ // 처음 구매하는 거라면.
								item_quantity1 = 1;
							}
							
							alert(tmp.item_name + "(이)가 구매되었습니다. 감사합니다.");
							
							firebase.database().ref('user_market/purchase/' + user_id + "/" + tmp.item_name).set({
								item_name:tmp.item_name,
								item_quantity:item_quantity1,
								saler_name:tmp.user_id,
							});
							}
						
					});
				});
				
				}
			}
		//표 수량 체크
		for(var count = 1; count < tablep.rows.length; count++)
			{
			if(tablep.rows[count].cells[2].innerHTML == 0)
				{
				tablep.deleteRow(count);
				}
			}
		
		for(var count = 1; count < table_s.rows.length; count++)
			{
			if(table_s.rows[count].cells[2].innerHTML == 0)
				{
				table_s.deleteRow(count);
				}
			}
		if(check_count == 0)// 구매한 물품 있는지 검사.
			{
			alert("체크된 항목이 없습니다.");
			}
		quantity_check(); // 데이터베이스 수량 체크.
	}
	
	function purchase_cart() // 장바구니에 있는 것 구매 함수
	{
		var user_id = "<%=id%>";
		var sale_data = firebase.database().ref('user_market/sale');
		var purchase_data = firebase.database().ref('user_market/purchase');
		var table_check = document.getElementsByName("cart_item1");//배열로 얻어와서 전체 목록 돌아가면서 체크된 것 수량 하나 빼고 구매 데이터에 올리는 식으로!
		var check_count = 0;
		var table_quantity; // 장바구니에 담긴 수량
		var tablep = document.getElementById("purchase_table");
		var table_s = document.getElementById("sale_info_table");
		var table1 = document.getElementById("shopping_cart_table");
		for(var i = 0; i < table_check.length; i++)
			{
			if(table_check[i].checked == true)
				{
				check_count = 1;
				var j = i + 1;
				table_quantity = table1.rows[j].cells[1].innerHTML;
				sale_data.once('value', function(snapshot){
					snapshot.forEach(function(childSnapshot){
						var tmp = childSnapshot.val();
						var key = childSnapshot.key;
						if(tmp.item_name == table_check[i].value)
						{
							var sale_q = tmp.item_quantity;
							if(parseInt(sale_q) < parseInt(table_quantity)) // 수량이 초과되면 구매 기능 실행하지 않고 다음 체크된 목록으로 넘어가게!
								{
								alert("장바구니에 담긴 " + tmp.item_name+ "의 수량이 초과되었습니다.");
								
								}
							else
								{
								sale_q = parseInt(sale_q) - parseInt(table_quantity);
								//구매 테이블 수량 감소
								for(var count = 1; count < tablep.rows.length; count++)
									{
									if(tablep.rows[count].cells[0].innerHTML == tmp.item_name)
										{
										tablep.rows[count].cells[2].innerHTML = sale_q;
										}
									}
								//판매 테이블 수량 감소.
								for(var count = 1; count < table_s.rows.length; count++)
									{
									if(table_s.rows[count].cells[0].innerHTML == tmp.item_name)
										{
										table_s.rows[count].cells[2].innerHTML = sale_q;
										}
									}
								firebase.database().ref("user_market/sale/" + key + '/item_quantity').set(sale_q);//판매 수량 빼줌
								var purchase_q = 0; //구매한 적이 있는지 알아보기 위해 구매 데이터의 수량 넣을 변수
								firebase.database().ref("user_market/purchase/" + user_id).once('value', function(snapshot){
									snapshot.forEach(function(childSnapshot){
										var tmp1 = childSnapshot.val();
										if(tmp1.item_name == tmp.item_name) //구매한 적 있을 때
											{
											purchase_q = tmp1.item_quantity;
											}
										
									});
								});
								if(purchase_q == 0)
									{
									firebase.database().ref("user_market/purchase/" + user_id + "/" + tmp.item_name).set({
										item_name:tmp.item_name,
										item_quantity:table_quantity,
										saler_name:tmp.user_id,
									});
									}
								else
									{
									table_quantity = parseInt(purchase_q) + parseInt(table_quantity);
									firebase.database().ref("user_market/purchase/" + user_id + "/" + tmp.item_name).set({
										item_name:tmp.item_name,
										item_quantity:table_quantity,
										saler_name:tmp.user_id,
									});
									}
								
								alert(tmp.item_name + "(이)가 구매되었습니다. 감사합니다.");
								
								}
						}
					});
				});
				}
			}
		
		
		if(check_count == 0)// 구매한 물품 있는지 검사.
			{
			alert("체크된 항목이 없습니다.");
			}
		//표에서 검사하고 삭제.
		for(var count = 1; count < tablep.rows.length; count++)
			{
			if(tablep.rows[count].cells[2].innerHTML == 0)
				{
				tablep.deleteRow(count);
				}
			}
		
		for(var count = 1; count < table_s.rows.length; count++)
			{
			if(table_s.rows[count].cells[2].innerHTML == 0)
				{
				table_s.deleteRow(count);
				}
			}
		quantity_check(); // 데이터베이스 수량 체크.
		
	}
</script>
<div id = "leftframe">
<p style = "border-bottom:1.5px solid;text-align:justify;">
<span id = "id" style = "font-size:26px;">
<%=id %></span>님 안녕하세요! <input type = "button" value = "LOGOUT" onclick = "logout()"onmouseover = "this.style.color = 'crimson'" onmouseout = "this.style.color = 'black'">
<span style = "float:right;margin-right:9px;font-size:20px;" id = "time1"></span>
</p>

<script>
setInterval("nowTime()", 1000);

</script>

<p style = "text-align:center;width:100%;">
<span style = "text-align:center;font-size:40px;">MARKET</span></p>
<div id = "sale_board">
<h2>SALE</h2>

<h3>sale status</h3>
<div id = "sale_info">
<br>
<center>
<table id = "sale_info_table" border = "1">
<tr><td>비고</td><td>제품명</td><td>가격</td><td>수량</td></tr>
</table>
</center>
<br>
<input type = "button" value = "DELETE" onclick = "sale_fail()" onmouseover = "this.style.color = 'LightCoral'" onmouseout = "this.style.color = 'black'">
</div><br>

<h3>sale registration</h3>
<div id = "sale_add">
<form style = "width:30%;margin-left:20%;"><br><br>
<table>
<tr><td>NAME</td><td><input type = "text" id = "sale_item_name"></td></tr>
<tr><td>PRICE</td><td><input type = "text" id = "sale_item_price"></td></tr>
<tr><td>QUANTITY</td><td><input type = "text" id = "sale_item_quantity"></td></tr>
</table><br>
</form>
<input type = "button" value = "SALE START!" onclick = "sale_start()" onclick = "sale_fail()" onmouseover = "this.style.color = 'LightCoral'" onmouseout = "this.style.color = 'black'">
</div>
</div> 

<div id = "purchase_board">
<h2>PURCHASE</h2>
<input type = "text" id = "search" size = "50px" value = "제품명을 검색해 주세요."><input type = "button" value = "SEARCH" onclick = "searchItem()"onclick = "sale_fail()" onmouseover = "this.style.color = 'LightCoral'" onmouseout = "this.style.color = 'black'"><br><br>
<form>
<center>
<table id = "purchase_table" border = "1">
<tr>
<td>비고</td><td>제품명</td><td>가격</td><td>수량</td><td>판매자</td>
</tr>
</table>
</center>
</form>
<br>
<input type = "button" value = "PURCHASE" onclick = "go_purchase()"onclick = "sale_fail()" onmouseover = "this.style.color = 'LightCoral'" onmouseout = "this.style.color = 'black'">
<input type = "button" value = "ADD CART" onclick = "add_to_cart()"onclick = "sale_fail()" onmouseover = "this.style.color = 'LightCoral'" onmouseout = "this.style.color = 'black'">
<h3>shopping cart</h3>
<div id = "shopping_cart">
<center>
<table id = "shopping_cart_table" border = "1">
<tr>
<td>비고</td><td>제품명</td><td>수량</td>
</tr>
</table></center>
<br>
<input type = "button" value = "PURCHASE" onclick = "purchase_cart()" onclick = "sale_fail()" onmouseover = "this.style.color = 'LightCoral'" onmouseout = "this.style.color = 'black'">
</div>
<br>
</div>

</div>	
<div id = "rightframe">
<p style = "width:90%;font-size:35px;border-bottom:1.5px solid;text-align:center;margin-left:5%;" id = "board_logo">BOARD</p>
<div id = "board_main" style = "border:1.5px solid;background-color:white;width:90%;height:700px;margin-left:5%;"></div><br>
<form>
<textarea  onKeyUp = "checkTextLength(this)" id = "board_input" name = "board_input" style = "width:88%;margin-left:5%;height:100px;">텍스트를 입력해주세요.(100자까지 입력 가능)</textarea><br>
<center><input type = "button" value = "POST" onclick = "postText()"onclick = "sale_fail()" onmouseover = "this.style.color = 'LightCoral'" onmouseout = "this.style.color = 'black'"></center> <!-- <center>태그 쓰면 가운데 정렬! -->
</form>
</div>
<script>
marketReady();

function marketReady() // 미리 판매자창이랑 구매자창 준비해서 띄워놓는 함수. (+ 게시판)
{
	var table1 = document.getElementById("sale_info_table");
	
	firebase.database().ref('/user_market/sale').once('value', function(snapshot){ //판매창
		snapshot.forEach(function(childSnapshot){
			var tmp = childSnapshot.val();
			
			
				if(tmp.user_id == user_id)
				{
				var key = childSnapshot.key; // 자동 키 값 모르기 때문에 가져오는 법!
				var new_tr1 = document.createElement("tr");
				
				var td_check1 = document.createElement("input");
				td_check1.setAttribute("type", "checkbox");
				td_check1.setAttribute("value", tmp.item_name);
				td_check1.setAttribute("name", "sale_item1");
				new_tr1.appendChild(td_check1);
				
				var td_name1 = document.createElement("td");
				td_name1.innerHTML = tmp.item_name;
				new_tr1.appendChild(td_name1);
				
				var td_price1 = document.createElement("td");
				td_price1.innerHTML = tmp.item_price;
				new_tr1.appendChild(td_price1);
				
				var td_quantity1 = document.createElement("td");
				td_quantity1.innerHTML = tmp.item_quantity;
				new_tr1.appendChild(td_quantity1);
				
				table1.appendChild(new_tr1);
				
				
				
				}
			
			
				});
		});
	var table = document.getElementById("purchase_table");
	firebase.database().ref("/user_market/sale").once('value', function(snapshot){ //구매 창
		snapshot.forEach(function(childSnapshot){
			
			var tmp = childSnapshot.val();
			var new_tr = document.createElement("tr");
			
			var td_check = document.createElement("input");
			td_check.setAttribute("type", "checkbox");
			td_check.setAttribute("value", tmp.item_name);
			td_check.setAttribute("name", "purchase_item1");
			new_tr.appendChild(td_check);
			
			var td_name = document.createElement("td");
			td_name.innerHTML = tmp.item_name;
			new_tr.appendChild(td_name);
			
			var td_price = document.createElement("td");
			td_price.innerHTML = tmp.item_price;
			new_tr.appendChild(td_price);
			
			var td_quantity = document.createElement("td");
			td_quantity.innerHTML = tmp.item_quantity;
			new_tr.appendChild(td_quantity);
			
			
			var td_saler = document.createElement("td");
			td_saler.innerHTML = tmp.user_id;
			new_tr.appendChild(td_saler);
			
			table.appendChild(new_tr);
			
			
			
			
		});
	});
	
	firebase.database().ref('user_market/marketboard').once('value', function(snapshot){ // 게시판
		snapshot.forEach(function(childSnapshot){
			
			var tmp = childSnapshot.val();
			var total_time = tmp.post_time;
			var str_id = tmp.user_id;
			var post_str = str_id + ' ' + total_time + '\n' + tmp.user_text;
			if(document.createElement) // node로 넣는 객체
			{
			var input_text = document.createElement("div");
			input_text.innerText = post_str;
			var par = document.getElementById("board_main");
			par.appendChild(input_text);
			}
		
			});
		
	});
	
}S
	function searchItem() // item 검색 함수.
	{
		var user_search = document.getElementById("search").value;
		var count = 0;
		firebase.database().ref('/user_market/sale').once('value', function(snapshot){
			snapshot.forEach(function(childSnapshot){
				var tmp = childSnapshot.val();
				if(tmp.item_name == user_search)
					{
					alert("제품명 : " + tmp.item_name + " 가격 : " + tmp.item_price + " 수량 : " + tmp.item_quantity + 
							" 판매자 : " + tmp.user_id);
					count++;
					}
			});
		});
		if(count == 0)
			{
			alert("검색하신 품목이 존재하지 않습니다.");
			}
		
		return;
	}
	
	function sale_fail() // 판매자가 판매 상품 삭제하는 부분.
	{
		var table_check = document.getElementsByName("sale_item1");
		var check_count = 0;
		for(var i = 0; i < table_check.length; i++)
			{
			if(table_check[i].checked == true) // 체크되었다면
				{
				check_count++;
				var item_name1 = table_check[i].value;
				firebase.database().ref('user_market/sale').once('value', function(snapshot){
					snapshot.forEach(function(childSnapshot){
						
						var tmp = childSnapshot.val();
						var key = childSnapshot.key;
						if(item_name1 == tmp.item_name)
							{
							
							firebase.database().ref('user_market/sale/' + key).remove();
							var table1 = document.getElementById('sale_info_table');
							table1.deleteRow(i + 1); // 판매자 표에서 삭제.
							var table2 = document.getElementById("purchase_table");
							for(var k = 1; k < table2.rows.length; k++)
								{
								
								if(table2.rows[k].cells[0].innerHTML == item_name1)
									{
									table2.deleteRow(k); // 구매 표에서 삭제
									}
								}
							alert(item_name1 + "(이)가 삭제되었습니다.");
							}
					});
				});
				}
			}
		if(check_count == 0) // 체크된 거 있나 검사.
			{
			alert("체크된 항목이 없습니다.");
			}
		
	}
	function add_to_cart() // 장바구니에 넣는 함수.
	{
		var table_check = document.getElementsByName("purchase_item1");
		var table1 = document.getElementById("shopping_cart_table");
		var count = 0;
		//만약 이미 장바구니에 존재한다면 수량을 1 더한다.
		
		for(var i = 0; i < table_check.length; i++) 
			{
			count = 0;
			
			if(table_check[i].checked == true)
				{
				for(var j = 1; j < table1.rows.length; j++)
				{
					
				if(table1.rows[j].cells[0].innerHTML == table_check[i].value)// 장바구니에 있을 경우
					{
					count = 1;
					var q = table1.rows[j].cells[1].innerHTML;
					q = parseInt(q);
					q++;
					
					table1.rows[j].cells[1].innerHTML = q;//수량 1더해서 추가.
					}
				}
				if(count == 0){ //장바구니에 없을 경우
				if(document.createElement)
					{
					var new_tr = document.createElement("tr");
					
					var td_check = document.createElement("input");
					td_check.setAttribute("type", "checkbox");
					td_check.setAttribute("name", "cart_item1");
					td_check.setAttribute("value", table_check[i].value); // item 이름 value로 가진다
					new_tr.appendChild(td_check);
					
					var td_name = document.createElement("td");
					td_name.innerHTML = table_check[i].value;
					new_tr.appendChild(td_name);
					
					var td_num = document.createElement("td");
					td_num.innerHTML = 1;
					new_tr.appendChild(td_num);
					
					table1.appendChild(new_tr);
					
					}
				}
				}
			}
	}
</script>
</body>
</html>