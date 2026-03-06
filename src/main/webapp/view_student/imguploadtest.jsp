<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제목을 입력하세요</title>
</head>
<body>
	<input type="file" id="image" name="image" accept="image/*"
		onchange="previewImages(event)" multiple>
	<div id="preview" style="display: flex; flex-wrap: wrap;"></div>

	<script>
	function previewImages(event) {
        const files = event.target.files;

        // 미리보기 영역을 초기화합니다.
        const preview = document.getElementById('preview');
        preview.innerHTML = "";  // 기존 미리보기를 초기화

        // 파일이 5개를 초과하면 처리하지 않음
        if (files.length > 5) {
            alert("최대 5개의 이미지만 업로드할 수 있습니다.");
            event.target.value = ""; // 파일 선택 초기화
            return;
        }

        // 선택한 파일들을 순회하며 미리보기 생성
        for (let i = 0; i < files.length; i++) {
            if (files[i]) {
                const reader = new FileReader();

                reader.onload = function(e) {
                    // 각 이미지 미리보기를 위한 <img> 태그 생성
                    const img = document.createElement("img");
                    img.src = e.target.result;
                    img.style.width = "200px";  // 이미지의 가로 크기
                    img.style.height = "200px"; // 이미지의 세로 크기
                    img.style.margin = "5px";  // 이미지 간의 간격
                    preview.appendChild(img);
                };

                reader.readAsDataURL(files[i]);
            }
        }
    }
	</script>

</body>
</html>
