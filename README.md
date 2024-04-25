# LIVE-RARY
<img src="https://github.com/gyu9907/live-rary/blob/master/src/main/webapp/image/logo5.png" width="400"/>

## 1. 프로젝트 설명
이 프로젝트는 도서관 데이터베이스를 관리하는 웹 애플리케이션 개발을 목표로 진행하였다.<br/>
고객은 집에서 쉽게 웹으로 도서를 검색할 수 있다. 그리고 찾는 도서가 대출 중인지 확인할 수 있고, 대출 예약을 할 수 있다. 대출한 도서에 대해서는 대출 연장을 할 수 있고, 연체 알림도 볼 수 있다.
사서는 도서를 고객에게 도서를 대출해주거나 고객의 도서를 반납처리할 수 있고, 새로운 도서를 등록, 기존 등록된 도서를 삭제할 수 있다.
- **로그인 화면**<br/><img src="https://github.com/gyu9907/live-rary/assets/108111779/1699a6e8-be89-4baa-ab5d-ae0add6243e9" width="400"/>
- **고객 메인 화면**<br/><img src="https://github.com/gyu9907/live-rary/assets/108111779/311013e7-9d4f-4988-ac0a-97304adb8c2b" width="800"/>
- **사서 메인 화면**<br/><img src="https://github.com/gyu9907/live-rary/assets/108111779/f98207ba-9955-483f-bc4f-766a608ea716" width="800"/>

#### 개발 주요 사항
- **AJAX**를 사용
- **세션** 방식으로 로그인 구현
- SQL 쿼리문 작성
- CSS 디자인

## 2. 기술 스택
- **언어** : Java(JSP), JavaScript, HTML, CSS
- **엔진** : Apache Tomcat
- **툴** : Eclipse
- **DB** : MySQL
- **오픈소스 & 라이브러리** : 공공데이터 API
![asdf](https://github.com/gyu9907/live-rary/assets/108111779/b078e8ea-1292-4a8b-83cb-674a16cf14df)

## 3. 팀원
- **김규빈** : 로그인, 회원가입, 마이페이지(회원정보 수정, 회원탈퇴), 사서 메인화면과 고객 메인화면 기획, 책 검색, 전체 CSS 디자인
- **홍상혁**(팀장) : 사서 기능(대출, 반납, 신규 도서 등록, 책 삭제), 시나리오
- **진민주** : 고객 기능 (알람(연체, 대출 가능 목록), 대출(확인 및 연장), 예약(예약 및 취소)), 책 검색

## 4. 개발 기간
2022.11.26 ~ 2022.12.24

## 5. 배운 점과 어려웠던 점
### 배운 점
- **Ajax를 사용해서 비동기식 통신 구현** : Ajax를 사용하면 페이지 전체를 새로고침 할 필요 없이 일부 Element만 업데이트할 수 있으므로, 요청에 대한 응답만을 기다리지 않고 다른 작업을 동시에 할 수 있다.<br/>
예를 들어 회원가입 화면의 경우 아이디가 중복인지 확인하기 위해 기다리지 않고, 비밀번호를 입력할 때 아이디가 중복인지 자동으로 확인할 수 있다.<br/>
아래 코드는 아이디 중복 확인을 위한 Ajax 코드이다.<br/>
#### <signup.html>
```javascript
var request = null;
function createRequest() {
	try {
		request = new XMLHttpRequest();
	} catch(failed) {
		request = null;
	}
	if(request == null)
		alert("Error creating request object!");
}
```
먼저, 위와 같이 request를 생성한다.

**<signup.html>**
```javascript
function checkId() {
...
	createRequest();
	var id = document.getElementById('id').value;
	var qry = "menu=1&id="+id;
	var url = "signupAction.jsp?";
	request.open("POST", url, true);
	request.onreadystatechange = updatePage;
	request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	request.send(qry);
```
그 후 signupAction.jsp에 POST방식으로 요청하면, signupAction.jsp에서는 아래 구문에서 아이디 중복을 확인한다.<br/><br/>
**<signupAction.jsp>**
```javascript
...
switch(menu){
case 1:
			sql = "select * from user where id like ?";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			ResultSet result = pstmt.executeQuery();
			if(result.next() == true){
				out.println("/결과/중복있음/결과/");
			}
			else {
				out.println("/결과/중복없음/결과/");
			}
			break;
...
}
```
데이터베이스에 sql문으로 검색하여 아이디 중복을 확인한다. signup.html에서 응답으로 "중복있음" 또는 "중복없음"을 수신하면 결과에 따라 페이지를 업데이트한다.<br/><br/>
**<signup.html>**
```javascript
function updatePage(){
	var label = document.getElementById("idLabel");
	if(request.readyState==4 && request.status==200){
		var result = request.responseText;
		result=result.split("/결과/")[1];
		if(result=="중복없음"){
			label.innerHTML = "사용 가능한 아이디 입니다.";
			label.style.color="green";
		}
		else {
			label.innerHTML = "이미 사용중인 아이디 입니다.";
			label.style.color="red";
			
		}
	} else {
		label.innerHTML = "통신 오류";
		label.style.color="red";
	}
}
```
request를 정상적으로 수신하였는지 확인한다. request를 정상적으로 수신하였다면 아이디 중복 여부를 확인한다.
"중복없음"을 수신하면 "사용 가능한 아이디 입니다."를 출력, "중복있음"을 수신하면 "이미 사용중인 아이디 입니다."를 출력한다.
만약 request를 정상적으로 수신하지 못한 경우 "통신오류"를 출력한다.
위의 과정이 아이디 입력 후 커서를 옮기면 비동기 방식으로 이루어지는 것이다.

### 어려웠던 점
- **3명간 협업** : 팀 프로젝트를 처음 시도해봐서 어려운 부분이 있었다. 특히 짧은 시간내로 완성해야 하는 프로젝트였으므로, 빠른 개발속도가 중요했다. 그러나 팀원들이 초기에 다른 일정으로 인해 개발에 참여하기 어려웠기에 나는 빠르게 기본 틀을 기획하였다.<br/>
로그인, 회원가입, 고객 메인화면, 사서 메인화면, 고객의 도서 검색을 구현하였고, 이를 토대로 팀원들이 고객과 사서의 세부 기능을 구현하기 쉽게 준비했다. 그리고 데이터베이스를 MySQL로 구성하고, 집에 있는 작은 컴퓨터로 언제든 접속 가능하도록 만들었다.<br/>
덕분에 팀원들은 헤매지 않고 빠르게 개발을 진행할 수 있었으며, 일관된 데이터베이스로 개발을 진행할 수 있었다. 이후 팀원들이 개발하면서 생긴 오류에 대해 질문을 주고 받으며 수정해 나갔다.<br/>
파일을 주고 받으며 생기는 작은 문제들이 있었으며, 이후 프로젝트부터 형상관리를 원활하게 하기 위해 github를 사용하게 되었다.<br/><br/>
아래는 개발하면서 사용했던 진행도이다.
![image](https://github.com/gyu9907/live-rary/assets/108111779/79feb49e-68b0-4e8b-9164-94873c13ba3b)
