//아이디		 
$("#id").focusout(function() {
	console.log("id check");
	const userid = $("#id").val().trim();
	
	if (userid.length < 3 || userid.length > 20) {
	        $("#idInput").text("아이디는 3~20글자 사이로 입력해주세요.").css("color", "red");
	        return;
	    }
		//입력한 아이디가 DB에 저장되어 있는지 없는지 확인 요청
		//Ajax기술을 이용 하여 비동기 방식으로 MemberController로 합니다.
		$.ajax({
				url:contextPath+"/admin/joinIdCheck.me",
				type: "post",
				async: true,  //비동기통신
				data: { user_id: userid },  // MemberController 서버페이지에 요청할 값 설정
				dataType: "text",  // MemberController서버페이지로 부터 예상 응답받을 데이터 종류 설정
				success: function(data) {   //요청통신에 성공했을 때 콜백함수가 자동으로 호출됨. 
					//data매개변수로 MemberController가 응답한 데이터가 넘어옴.
					/*not_usable 또는 usable 둘 중 하나를 data매개변수로 전달 받는다*/
					//MemberController서버페이지에서 전송된 아이디 중복?인지 아닌지 판단하여 현재 join.jsp중앙화면에 보여주는 구문처리
					if (data === "not_usable") {  //id가 DB에 없으면?
						$("#idInput").text("이미 사용중인 ID입니다.").css("color", "red");
					} else {   // id가 DB에 있으면
						$("#idInput").text("사용할 수 있는 ID입니다.").css("color", "blue");
					}
				}
			});
		}
);


//비밀번호
$("#pass").focusout(function() {
	if ($("#pass").val().length < 4) {
		$("#passInput").text("한글,특수문자 없이 4글자 이상으로 작성해 주세요!").css("color", "red");
	} else {
		$("#passInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}
});

//이름
$("#name").focusout(function() {
	if ($("#name").val().length < 2 || $("#name").val().length > 6) {
		$("#nameInput").text("이름을 제대로 작성하여주세요.").css("color", "red");
	} else {
		$("#nameInput").text("이름입력완료!").css("color", "blue");
	}
});


//생년월일
$("#birthDate").focusout(function() {

	var birthDate = $("#birthDate");
	var birthValue = birthDate.val();
	birthValue = $.trim(birthValue);

	// 현재 날짜와 비교를 위해 오늘 날짜 생성
	var today = new Date();
	var birthDate = new Date(birthValue);

	if (birthValue == "") {
		$("#birthDateInput").text("생년월일을 입력해주세요").css("color", "red");
	} else if (birthDate > today) {
		$("#birthDateInput").text("미래의 날짜는 입력할 수 없습니다").css("color", "red");
	} else {
		$("#birthDateInput").text("유효한 생년월일입니다").css("color", "blue");
	}
});



//성별
$(".gender").click(function() {
	$("#genderInput").text("성별체크완료!").css("color", "blue");
});


//주소
$("input[name='address1'],input[name='address2'],input[name='address3'],input[name='address4'],input[name='address5']").focusout(function() {
	if ($("input[name='address1']").val() == "" ||
		$("input[name='address2']").val() == "" ||
		$("input[name='address3']").val() == "" ||
		$("input[name='address4']").val() == "" ||
		$("input[name='address5']").val() == "") {
		$("#addressInput").text("주소를 모두 작성하여주세요.").css("color", "red");
	} else {
		$("#addressInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}
});



//전화번호
$("#tel").focusout(function() {
	var t = $("#tel");
	var telVal = t.val();
	var tReg = RegExp(/^0[0-9]{8,10}$/);
	var rsTel = tReg.test(telVal);
	if (!rsTel) {
		$("#telInput").text("전화번호 형식이 올바르지 않습니다.").css("color", "red");
	} else {
		$("#telInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}
});


//이메일
$("#email").focusout(function() {
	var mail = $("#email");
	var mailValue = mail.val();
	var mailReg = /^\w{5,12}@[a-z]{2,10}[\.][a-z]{2,3}[\.]?[a-z]{0,2}$/;
	var rsEmail = mailReg.test(mailValue);

	if (!rsEmail) {
		$("#emailInput").text("이메일 형식이 올바르지 않습니다.").css("color", "red");

	} else {
		$("#emailInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}
});

//관리자번호
$("#admin_id").focusout(function() {
	var admin = $("#admin_id");
		var adminValue = admin.val();
		var adminReg = /^A\d+$/;
		var rsAdmin = adminReg.test(adminValue);

		if (!rsAdmin) {
			$("#adminInput").text("관리자번호 형식이 올바르지 않습니다.").css("color", "red");
			admin.focus();
			return false;
		} else {
			$("#adminInput").text("올바르게 입력되었습니다.").css("color", "blue");
		}

});


//부서
$("#department").click(function() {

	// 선택한 부서 값 가져오기
	var selectedDepartment = $("#department").val();

	// 유효성 검사
	if (!selectedDepartment) { // 부서가 선택되지 않은 경우
		$("#departmentInput").text("부서를 선택해주세요").css("color", "red");
	} else {
		$("#departmentInput").text("부서가 선택되었습니다.").css("color", "blue");
	}
});




//관리자권한
$("#access").focusout(function() {
	var access = $("#access");
	var accessValue = access.val();
	accessValue = $.trim(accessValue);
	
	if (accessValue == "") {

		$("#accessInput").text("권한을 작성해주세요.").css("color", "red");

		return false;

	} else {
		$("#accessInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}

});



//----------------------------------------------------------------------------

//회원가입 버튼 클릭시 호출되는 함수
function check() {


	//아이디	
	var id = $("#id");
	var idValue = id.val();

	var idReg = RegExp(/^[A-Za-z0-9_\-]{3,20}$/);
	var resultId = idReg.test(idValue);

	if (!resultId) {
		$("#idInput").text("한글,특수문자 없이 3~20글자사이로 작성해 주세요!").css("color", "red");
		id.focus();

		return false;
	} else {
		$("#idInput").text("올바르게 입력되었습니다.").css("color", "blue");

	}

	//====================================================================================================

	// 패스워드
	var pass = $("#pass");
	var passValue = pass.val();

	var passReg = RegExp(/^[A-Za-z0-9_\-]{4,20}$/);
	var resultPass = passReg.test(passValue);

	if (!resultPass) {
		$("#passInput").text("한글,특수문자 없이 4글자 이상으로 작성해 주세요!").css("color", "red");
		pass.focus();

		return false;
	} else {
		$("#passInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}

	//====================================================================================================

	// 이름
	var name = $("#name");
	var nameValue = name.val();

	var nameReg = RegExp(/^[가-힣]{2,6}$/);
	var resultName = nameReg.test(nameValue);

	if (!resultName) {
		$("#nameInput").text("이름을 한글로 작성하여주세요.").css("color", "red");
		name.focus();

		return false;
	} else {
		$("#nameInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}

	//====================================================================================================

	//생년월일
	//입력된 생년월일 값 가져오기
	var birthDate = $("#birthDate");
	var birthValue = birthDate.val();
	birthValue = $.trim(birthValue);

	// 현재 날짜와 비교를 위해 오늘 날짜 생성
	var today = new Date();
	var birthDate = new Date(birthValue);

	if (birthValue == "") {
		$("#birthDateInput").text("생년월일을 입력해주세요").css("color", "red");
	} else if (birthDate > today) {
		$("#birthDateInput").text("미래의 날짜는 입력할 수 없습니다").css("color", "red");
	} else {
		$("#birthDateInput").text("유효한 생년월일입니다").css("color", "blue");
	}

	//====================================================================================================


	// 회원가입 버튼 클릭 시 유효성 검사
	var gender = $(".gender:checked");
	if (gender.length === 0) {
	    $("#genderInput").text("성별을 체크 해주세요.").css("color", "red");
	    return false;
	} else {
	    $("#genderInput").text("성별이 체크되었습니다.").css("color", "blue");
	}

	//====================================================================================================

	//주소
	var address1 = $("#sample4_postcode");
	var address2 = $("#sample4_roadAddress");
	var address3 = $("#sample4_jibunAddress")
	var address4 = $("#sample4_detailAddress");
	var address5 = $("#sample4_extraAddress");
	var addVal1 = address1.val();
	var addVal2 = address2.val();
	var addVal3 = address3.val();
	var addVal4 = address4.val();
	var addVal5 = address5.val();
	if (addVal1 == "" || addVal2 == "" || addVal3 == "" || addVal4 == "" || addVal5 == "") {
		$("#addressInput").text("주소를 모두 작성하여주세요.").css("color", "red");
		address5.focus();

		return false;
	} else {
		$("#addressInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}

	//====================================================================================================

	//전화번호
	var tel = $("#tel");

	var telValue = tel.val();

	var telReg = RegExp(/^0[0-9]{8,10}$/);

	var resultTel = telReg.test(telValue);

	if (!resultTel) {
		$("#telInput").text("전화번호 형식이 올바르지 않습니다.").css("color", "red");

		tel.focus();

		return false;

	} else {
		$("#telInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}
	//====================================================================================================

	//이메일
	var email = $("#email");

	var emailValue = email.val();

	var emailReg = /^[a-zA-Z0-9._%+-]{4,}@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;


	var resultEmail = emailReg.test(emailValue);

	if (!resultEmail) {
		$("#emailInput").text("이메일 형식이 올바르지 않습니다.").css("color", "red");

		email.focus();

		return false;
	} else {
		$("#emailInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}

	//====================================================================================================


	//관리자번호	
	var admin = $("#admin_id");

	var adminValue = admin.val();

	var adminReg = /^A\d+$/;

	var rsAdmin = adminReg.test(adminValue);

	if (!rsAdmin) {
		$("#adminInput").text("관리자번호 형식이 올바르지 않습니다.").css("color", "red");

		admin.focus();

		return false;

	} else {
		$("#adminInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}

	//======================================================================

	//부서

	// 선택한 부서 값 가져오기
	var selectedDepartment = $("#department").val();

	// 유효성 검사
	if (!selectedDepartment) { // 부서가 선택되지 않은 경우
		$("#departmentInput").text("부서를 선택해주세요").css("color", "red");
		return false;

	} else {
		$("#departmentInput").text("부서가 선택되었습니다.").css("color", "blue");

	}
	//====================================================================================================


	//관리자권한	
	var access = $("#access");
	var accessValue = access.val();
	accessValue = $.trim(accessValue);
	if (accessValue == "") {

		$("#accessInput").text("권한을 작성해주세요.").css("color", "red");

		return false;

	} else {
		$("#accessInput").text("올바르게 입력되었습니다.").css("color", "blue");
	}


	//<form>으로 회원가입요청
	$("form").submit();
	alert("회원가입이 완료되었습니다!");

}//check 