<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, org.json.simple.JSONObject" %>
<html>
<head>
    <title>전국 중고 서점</title>
    <!-- Bootstrap CSS 추가 -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">    
    <!-- DataTables CSS 추가 -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.css">
    <!-- Kakao 지도 API -->
    <script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a68b84b3e58760b4694c7fd8bc747318"></script>
    <style>
        /* 지도와 리스트 레이아웃 */
        #content {
            display: flex;
            gap: 10px;
        }
		
		 .form-container {
            background: #ffffff;
            padding: 30px;
            margin: 0px auto 50px ;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
         /* 핸드폰 프레임 색상 변경 */
        .mobile-frame {
            width: 450px;
            height: 650px;
            border: 16px solid #555; /* 색상 변경 */
            border-top-width: 60px;
            border-bottom-width: 60px;
            border-radius: 36px;
            position: relative;
            box-sizing: border-box;
            overflow: hidden;
        }

        /* 테이블 열 너비 조정 */
        table.dataTable thead th {
            white-space: nowrap;
        }
        table.dataTable td:nth-child(3) {
            width: 150px; /* 전화번호 열 너비 */
        }

        #map {
            width: 100%;
            height: 100%;
        }

        #store-list {
            width: calc(100% - 520px);
            height: 650px;
            overflow-y: auto;
            padding: 10px;
            border: 1px solid #ddd;
        }

        /* 추가 정보 표시 영역 스타일 */
        #store-details {
            margin-top: 20px;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            #content {
                flex-direction: column;
                align-items: center;
            }
            .mobile-frame {
                margin-bottom: 20px;
            }
            #store-list {
                width: 100%;
                height: auto;
                display: block;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 페이지 헤더 -->
        <div class="text-center mb-4 mt-5">
            <h1 class="display-6"><i class="fas fa-book"  style="color: #4a90e2"></i> 전국 중고 서점</h1> <!-- 아이콘 변경 -->
            <p class="lead">전국에 있는 중고 서점을 찾아볼 수 있습니다.</p>
        </div>
        
        <div class="form-container">

        <!-- 지도와 리스트 -->
        <div id="content" class="d-flex gap-3">
            <!-- 모바일 프레임 -->
            <div class="mobile-frame">
                <!-- 지도 -->
                <div id="map"></div>
            </div>

            <!-- 매장 리스트 -->
            <div id="store-list">
                <!-- DataTable -->
                <table id="storeTable" class="table table-striped">
                    <thead>
                        <tr>
                            <th>시설명</th>
                            <th>주소</th>
                            <th>전화번호</th> <!-- 너비 조정됨 -->
                        </tr>
                    </thead>
                    <tbody>
                        <!-- JavaScript에서 동적으로 데이터 추가 -->
                    </tbody>
                </table>

                <hr>
                <!-- 선택한 매장 상세 정보 표시 영역 -->
                <div id="store-details" class="mt-4">
                    <!-- JavaScript에서 동적으로 상세 정보 추가 -->
                </div>
            </div>
        </div>
    </div>
    </div>

    <!-- Bootstrap과 jQuery JS 추가 -->
    <script src="https://code.jquery.com/jquery-3.5.1.js"></script>    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.min.js"></script>

    <!-- DataTables JS 추가 -->
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.js"></script>

    <script type="text/javascript">
        // JSP에서 데이터 받아오기
        var storeData = [];
        <% 
            List<JSONObject> apiData = (List<JSONObject>) request.getAttribute("apiData");
            if (apiData != null && !apiData.isEmpty()) {
                for (JSONObject data : apiData) {
        %>
                    storeData.push({
                        name: "<%= data.get("시설명") != null ? data.get("시설명") : "정보 없음" %>",
                        category: "<%= data.get("대분류명") != null ? data.get("대분류명") : "정보 없음" %>",
                        subCategory: "<%= data.get("중분류명") != null ? data.get("중분류명") : "정보 없음" %>",
                        postalCode: "<%= data.get("우편번호") != null ? data.get("우편번호") : "정보 없음" %>",
                        address: "<%= data.get("시설도로명주소") != null ? data.get("시설도로명주소") : "정보 없음" %>",
                        lat: parseFloat("<%= data.get("시설위도") != null ? data.get("시설위도") : "0" %>"),
                        lng: parseFloat("<%= data.get("시설경도") != null ? data.get("시설경도") : "0" %>"),
                        phone: "<%= data.get("전화번호") != null ? data.get("전화번호") : "정보 없음" %>",
                        weekdayOpen: "<%= data.get("평일개점시간") != null ? data.get("평일개점시간") : "정보 없음" %>",
                        weekdayClose: "<%= data.get("평일마감시간") != null ? data.get("평일마감시간") : "정보 없음" %>",
                        saturdayOpen: "<%= data.get("토요일개점시간") != null ? data.get("토요일개점시간") : "정보 없음" %>",
                        saturdayClose: "<%= data.get("토요일마감시간") != null ? data.get("토요일마감시간") : "정보 없음" %>",
                        sundayOpen: "<%= data.get("일요일개점시간") != null ? data.get("일요일개점시간") : "정보 없음" %>",
                        sundayClose: "<%= data.get("일요일마감시간") != null ? data.get("일요일마감시간") : "정보 없음" %>",
                        holidayOpen: "<%= data.get("휴무일개점시간") != null ? data.get("휴무일개점시간") : "정보 없음" %>",
                        holidayClose: "<%= data.get("휴무일마감시간") != null ? data.get("휴무일마감시간") : "정보 없음" %>",
                        holidayInfo: "<%= data.get("휴무일안내내용") != null ? data.get("휴무일안내내용").toString().replace("\"", "\\\"") : "정보 없음" %>"
                    });
        <% 
                } 
            }
        %>
        
        var mapContainer = document.getElementById('map');
        var mapOption = {
            center: new kakao.maps.LatLng(35.1542547, 129.05973686),
            level: 3
        };

        // 지도 생성
        var map = new kakao.maps.Map(mapContainer, mapOption);

        var storeTableBody = $('#storeTable tbody');

        var bounds = new kakao.maps.LatLngBounds();

        var markers = []; // 마커들을 저장할 배열
        var infowindows = []; // 인포윈도우들을 저장할 배열

        // 매장 데이터로 마커, 리스트 추가
        storeData.forEach(function(store, index) {
            // 마커 생성
            var markerPosition = new kakao.maps.LatLng(store.lat, store.lng);
            var marker = new kakao.maps.Marker({
                position: markerPosition,
                map: map
            });

            markers.push(marker); // 마커 배열에 추가

            bounds.extend(markerPosition); // Bounds에 마커 위치 추가

            // InfoWindow 생성
            var iwContent = '<div style="padding:5px; white-space: nowrap;">' +
                            '<b>' + store.name + '</b><br>' +
                            store.address + '<br>' +
                            (store.phone !== "정보 없음" ? '전화: ' + store.phone : '전화: 정보 없음') +
                        '</div>';
            var infowindow = new kakao.maps.InfoWindow({
                content: iwContent
            });

            infowindows.push(infowindow); // 인포윈도우 배열에 추가

            // 마커 클릭 이벤트
            kakao.maps.event.addListener(marker, 'click', function() {
                // 모든 인포윈도우 닫기
                infowindows.forEach(function(infowindow) {
                    infowindow.close();
                });
                infowindow.open(map, marker);
            });

            // 테이블에 데이터 추가
            var row = '<tr data-index="' + index + '">' +
                        '<td>' + store.name + '</td>' +
                        '<td>' + store.address + '</td>' +
                        '<td>' + store.phone + '</td>' +
                      '</tr>';
            storeTableBody.append(row);
        });

        // 지도 범위를 모든 마커가 보이도록 설정
        map.setBounds(bounds);

        // DataTable 초기화
        $(document).ready(function() {
            var table = $('#storeTable').DataTable({
                "lengthMenu": [5, 10], // 페이지 당 항목 수 설정
                "language": {
                    "decimal":        "",
                    "emptyTable":     "데이터가 없습니다.",
                    "info":           "_START_ - _END_ / _TOTAL_ 건",
                    "infoEmpty":      "0건",
                    "infoFiltered":   "(전체 _MAX_ 건 중 검색결과)",
                    "infoPostFix":    "",
                    "thousands":      ",",
                    "lengthMenu":     " _MENU_ 개씩 보기",
                    "loadingRecords": "로딩 중...",
                    "processing":     "처리 중...",
                    "search":         "검색:",
                    "zeroRecords":    "검색 결과가 없습니다.",
                    "paginate": {
                        "first":      "처음",
                        "last":       "마지막",
                        "next":       "다음",
                        "previous":   "이전"
                    },
                    "aria": {
                        "sortAscending":  ": 오름차순 정렬",
                        "sortDescending": ": 내림차순 정렬"
                    }
                }
            });

            // 테이블 행 클릭 시 지도 이동 및 인포윈도우 열기
            $('#storeTable tbody').on('click', 'tr', function () {
                var index = $(this).data('index');
                var store = storeData[index];
                var position = new kakao.maps.LatLng(store.lat, store.lng);
                map.setCenter(position);
                map.setLevel(3); // 레벨 조정

                // 모든 인포윈도우 닫기
                infowindows.forEach(function(infowindow) {
                    infowindow.close();
                });
                // 해당 인덱스의 인포윈도우 열기
                infowindows[index].open(map, markers[index]);

                // 상세 정보 표시
                var detailsHtml = '<h4>' + store.name + '</h4>' +
                                  '<p><strong>주소:</strong> ' + store.address + '</p>' +
                                  '<p><strong>전화번호:</strong> ' + store.phone + '</p>' +
                                  '<p><strong>평일 영업시간:</strong> ' + store.weekdayOpen + ' ~ ' + store.weekdayClose + '</p>' +
                                  '<p><strong>토요일 영업시간:</strong> ' + store.saturdayOpen + ' ~ ' + store.saturdayClose + '</p>' +
                                  '<p><strong>일요일 영업시간:</strong> ' + store.sundayOpen + ' ~ ' + store.sundayClose + '</p>' +
                                  '<p><strong>휴무일 안내:</strong> ' + store.holidayInfo + '</p>';
                $('#store-details').html(detailsHtml);
            });
        });
    </script>
</body>
</html>
