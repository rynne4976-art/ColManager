# 🎓 ColManager - 대학 통합 관리 시스템 

> KH정보교육원 팀 프로젝트 — JSP + Servlet 기반 MVC 웹 애플리케이션
<br>
대학교 내 학사 관리 및 커뮤니티 기능을 통합하여 학생, 교수, 강의, 게시판 등을 관리할 수 있는 웹 서비스입니다. 

---

## 📋 목차

1. [프로젝트 소개](#-프로젝트-소개)
2. [기술 스택](#-기술-스택)
3. [실행 방법](#-실행-방법)
4. [프로젝트 구조](#-프로젝트-구조)
5. [주요 기능](#-주요-기능)
6. [데이터베이스 구조](#-데이터베이스-구조)
7. [역할 분배](#-역할-분배)

---

## 🎯 프로젝트 소개

| 항목 | 내용 |
|------|------|
| 프로젝트명 | 팀 대학교 학사 관리 시스템|
| 기간 | 25일 |
| 인원 | 5명 |
| 목표 | JSP + Servlet 기반 MVC 웹 애플리케이션 형태로 학사관리서비스 페이지 구현 |
<br>

> ### 사용자 역할 별 주요 기능

**👩‍🎓 학생(student)**
- 강의 목록 조회 및 수강 정보 확인
- 과제 목록 조회 및 과제 제출
- 게시판 글 작성 및 조회
- 마이페이지에서 개인 정보 확인

👉 학생은 학습 및 과제 수행 중심 기능을 사용합니다.
<br><br>
**👨‍🏫 교수 (Professor)**
- 강의 개설 및 강의 정보 관리
- 과제 등록 및 수정
- 학생 과제 제출 내역 조회
- 공지사항 및 게시글 작성

👉 교수는 강의 운영 및 과제 관리 기능을 담당합니다.
<br><br>

**🛠 관리자 (Admin)**
- 학생 및 교수 계정 관리 (등록, 수정, 삭제)
- 학과 및 전공 데이터 관리
- 강의 및 전체 시스템 데이터 관리
- 게시판 및 서비스 운영 관리

👉 관리자는 시스템 전반을 관리하는 최고 권한 사용자입니다.
<br><br>

---

## 🛠️ 기술 스택

| 구분 | 기술 |
|------|------|
| Language | Java |
| Web | Servlet / JSP |
| Database | Oracle |
| Server | Apache Tomcat |
| IDE | Eclipse |

---

## 🚀 실행 방법

### ⚙️ 사전 요구사항

- **JDK 8 이상**(권장: JDK 11 또는 JDK 21)
- **Apache Tomcat (9.0 권장)**
- **Eclipse IDE (Enterprise Edition)** 설치 필수!

### ▶️ 실행 순서

```bash
# 1. 저장소 클론
git clone https://github.com/rynne4976-art/ColManager.git

# 2. Eclipse 실행 후 프로젝트 Import
- File → Import → Existing Projects into Workspace

# 3. Tomcat 서버 설정
- Servers 탭 → Tomcat 추가

# 4. 프로젝트를 서버에 배포 후 실행
- 우클릭 → Run on Server

```

### 접속 주소

| 페이지 | URL |
|--------|-----|
| 메인 페이지 | [http://localhost:8080/ColManager ](http://localhost:8090/ColManager/member/main.bo)|

---

## 📁 프로젝트 구조

```

ColManager/
├── index.jsp
├── main.jsp
├── top.jsp
├── bottom.jsp
│
├── common/
│ ├── bookShopMap.jsp
│ ├── calendar.jsp
│ ├── floatingWidgets.jsp
│ ├── jobFair.jsp
│ ├── scholarSearch.jsp
│ ├── welcomRoad.jsp
│ └── notice/
│     ├── list.jsp
│     ├── read.jsp
│     ├── reply.jsp
│     └── write.jsp
│
├── css/
│ ├── bus.css
│ ├── calendarCSS.css
│ ├── classroom_styles.css
│ ├── jobFair.css
│ ├── startpage.css
│ └── widget.css │
├── js/
│ ├── bus.js
│ ├── jobFair.js
│ ├── scholar.js
│ ├── startcenterTimetable.js
│ └── studentTimetable.js
|
├── img/
├── images/
│
├── view_start/
│ └── startcenter.jsp
│
├── view_student/
│ ├── booktrading.jsp
│ ├── booktradingboard.jsp
│ ├── booktradingread.jsp
│ ├── studentTimetableMini.jsp
│ └── imguploadtest.jsp
│
├── view_admin/
│    ├── calendarEdit.jsp
│    ├── coursePeriod.jsp
│    ├── noticeManage.jsp
│    ├── roomRegister.jsp
│    ├── roomSearch.jsp
│    └── studentManager/
│         ├── studentManage.jsp
│         ├── viewStudent.jsp
│         └── viewStudentList.jsp
|
├── view_classroom/
│   ├── classroom.jsp
│   ├── courseList.jsp
│   ├── courseRegister.jsp
│   ├── gradeList.jsp
│   ├── studentTimetable.jsp
│   │
|   ├── assignment_notice/
|   |   ├── classroomRead.jsp
│   │   └── classroomWrite.jsp
│   │
│   ├── assignment_submission/
│   │   ├── assignmentManage.jsp
│   │   └── submitAssignment.jsp
│   │
│   ├── attendance/
│   │   ├── attendanceProfessor.jsp
│   │   └── attendanceStudent.jsp
│   └── evaluation/
│       ├── evaluationList.jsp
│       └── evaluationRegister.jsp
│
├── view_widget/
│   ├── aiwidget.jsp
│   ├── chatwidget.jsp
│   └── emailwidget.jsp
│
├── WEB-INF/
│   ├── web.xml
│   └── classes/
│       ├── Controller/
│       ├── Service/
│       ├── Dao/
│       ├── Vo/
│       ├── utils/
│       └── webSocket/
│
└── lib/
|   ├── web.xml
|   └── context.xml
|
|

```
---
## 🚀 주요 기능

> ### 🏫 학사 관리 시스템
- 강의 개설 및 강의 목록 조회
- 수강 정보 및 강의별 상세 페이지 제공
- 성적 조회 및 평가 관리 기능
- 강의별 출석 관리 시스템
<br>

> ### 📝 과제 관리 시스템
- 과제 공지 등록 및 조회
- 과제 제출 기능 (파일 업로드 포함)
- 제출 내역 확인 및 관리
<br>

> ### 📅 일정 및 캘린더 기능
- 학사 일정 캘린더 조회
- 일정 등록 및 수정 기능
- 주요 행사 및 일정 시각화
<br>

> ### 📢 게시판 시스템 (공지/커뮤니티)
- 공지사항 CRUD (작성, 조회, 수정, 삭제)
- 게시글 답글(Reply) 기능
- 게시글 목록 및 상세 조회
<br>

> ### 💬 실시간 채팅 & 위젯 기능
- WebSocket 기반 실시간 채팅 기능
- AI 위젯 / 이메일 위젯 / 채팅 위젯 제공
- 메인 화면에서 위젯 형태로 통합 제공
<br>

> ### 🚌 학내 편의 기능
- 학내 버스 시간표 조회 기능
- 취업 박람회(Job Fair) 정보 제공
- 도서 검색 및 학습 지원 기능
- 캠퍼스 안내 및 지도 기능
<br>

> ### 📚 학생 편의 기능
- 시간표 조회 (미니 시간표 포함)
- 중고 교재 거래 게시판
- 파일 업로드 테스트 및 활용 기능
<br>

> ### 🛠 관리자 운영 기능
- 학생 정보 관리
- 강의 및 학사 데이터 관리
- 강의실 및 시설 관리
- 공지 및 시스템 설정 관리
<br>

> ### 🔐 사용자 인증 및 관리
- 로그인 및 세션 기반 인증 처리
- 사용자 권한에 따른 기능 접근 제어
<br>

---
## 📊 ERD (데이터베이스 설계)

<img width="1676" height="1245" alt="ColManager edumanager sql" src="https://github.com/user-attachments/assets/dc1df32f-a15d-4b5e-a853-1a5c4f1c4f2b" />


---
> ### 📊 관계 정리

| 관계 | 설명 |
|------|------|
| User → Student / Professor / Admin | 1:1 (역할별 상세 정보) | 
| User → Book_post / Book_reply | 1:N (게시글 및 댓글 작성) | 
| Book_post → Book_reply / Book_image| 1:N (댓글 및 이미지) | 
| Course → Enrollment / Grade / Attendance | 1:N (수강, 성적, 출결 관리) | 
| Student → Enrollment / Grade / Attendance |1:N (학생 기준 학사 정보) | 
| Course → Assignment → Submission | 1:N (과제 및 제출 관리) | 
| Submission → Submission_file | 1:N (제출 파일) | 
| Course → Course_timetable | 1:N (강의 시간표) | 
| Course → Course_evaluation | 1:N (강의 평가) | 
| Major → Student / Professor | 1:N (전공 소속) | 
| Course → Classroom | N:1 (강의실 배정) |

---

## 📡 API 명세 요약

자세한 내용은 [docs/API_SPEC.md](docs/API_SPEC.md) 참조

| Method | URL | 설명 | 담당 |
|--------|-----|------|------|
| POST | /api/members/signup | 회원가입 | A |
| POST | /api/members/login | 로그인 | A |
| GET | /api/members/logout | 로그아웃 | A |
| GET | /api/restaurants | 맛집 목록 | B |
| GET | /api/restaurants/{id} | 맛집 상세 | B |
| POST | /api/restaurants | 맛집 등록 | B |
| PUT | /api/restaurants/{id} | 맛집 수정 | B |
| DELETE | /api/restaurants/{id} | 맛집 삭제 | B |
| GET | /api/restaurants/search | 맛집 검색 | B |
| GET | /api/reviews/restaurant/{id} | 리뷰 목록 | C |
| POST | /api/reviews | 리뷰 작성 | C |
| DELETE | /api/reviews/{id} | 리뷰 삭제 | C |
| GET | /api/wishlists | 찜 목록 | D |
| POST | /api/wishlists/{restaurantId} | 찜 추가 | D |
| DELETE | /api/wishlists/{restaurantId} | 찜 취소 | D |

---

## 👥 역할 분배

자세한 내용은 [docs/TODO_BY_ROLE.md](docs/TODO_BY_ROLE.md) 참조

| 역할 | 담당 영역 | 주요 파일 |
|------|----------|----------|
| **A** (회원) | 회원가입, 로그인/로그아웃, 세션 관리 | MemberService, MemberApiController, login.jsp, signup.jsp |
| **B** (맛집) | 맛집 CRUD, 검색, 카테고리 필터 | RestaurantService, RestaurantApiController, list.jsp, detail.jsp, form.jsp |
| **C** (리뷰) | 리뷰 작성/삭제, 별점 표시 | ReviewService, ReviewApiController, detail.jsp(리뷰 섹션) |
| **D** (찜+홈) | 찜하기, 홈 컨트롤러, 전체 JSP 보완 | WishlistService, WishlistApiController, HomeController |

---

## 🔑 테스트 계정

| 이메일 | 비밀번호 | 닉네임 | 역할 |
|--------|---------|--------|------|
| admin@test.com | 1234 | 관리자 | ADMIN |
| user1@test.com | 1234 | 맛집탐험가 | USER |
| user2@test.com | 1234 | 먹보킹 | USER |
