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
7. [API 명세 요약](#-API-명세-요약)
8. [역할 분배](#-역할-분배)
9. [대표 사용자 계정](#-대표-사용자-계정)

---

## 1. 🎯 프로젝트 소개

| 항목 | 내용 |
|------|------|
| 프로젝트명 | 팀 대학교 학사 관리 시스템|
| 기간 | 25일 |
| 인원 | 4명 |
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

## 2. 🛠️ 기술 스택

| 구분 | 기술 |
|------|------|
| Language | Java |
| Web | Servlet / JSP |
| Database | Oracle |
| Server | Apache Tomcat |
| IDE | Eclipse |

---

## 3. 🚀 실행 방법

### ⚙️ 사전 요구사항

- **JDK 21 이상**
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

## 4. 📁 프로젝트 구조

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
## 5. 🚀 주요 기능

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
## 6. 📊 데이터베이스 구조

<img width="1676" height="1245" alt="ColManager edumanager sql" src="https://github.com/user-attachments/assets/445ae599-905e-401a-a9a2-cdf70e88a627" />


---
## 7. 📡 API 명세 요약 

>### 🔐 회원 기능
| Method | URL | 설명 | 
|--------|-----|------| 
| POST | /member/login.do | 로그인 처리 | 
| GET | /member/logout.do | 로그아웃 | 
| POST | /member/register.do | 회원가입 | 
<br> 

> ### 🏫 강의 / 학사 기능
| Method | URL | 설명 | 
|--------|-----|------| 
| GET | /course/list.do | 강의 목록 조회 | 
| GET | /course/detail.do | 강의 상세 조회 | 
| POST | /course/register.do | 강의 개설 (교수) | 
| GET | /enrollment/list.do | 수강 목록 조회 | 
| POST | /enrollment/apply.do | 수강 신청 | 
<br> 

> ### 📝 과제 기능
| Method | URL | 설명 | 
|--------|-----|------| 
| GET | /assignment/list.do | 과제 목록 조회 | 
| POST | /assignment/create.do | 과제 등록 (교수) | 
| POST | /submission/submit.do | 과제 제출 | 
| GET | /submission/list.do | 제출 내역 조회 |
<br>

>### 📢 게시판 기능
| Method | URL | 설명 | 
|--------|-----|------|
| GET	| /board/list.do | 게시글 목록 조회 |
| GET |	/board/read.do | 게시글 상세 조회 |
| POST | /board/write.do	| 게시글 작성 |
| POST | /board/reply.do |	댓글 작성 |
| POST| /board/delete.do | 게시글 삭제 |
<br>

>### 📅 일정 / 기타 기능
| Method | URL | 설명 | 
|--------|-----|------|
| GET	| /calendar/view.do	| 학사 일정 조회 |
| POST | /calendar/edit.do | 일정 등록/수정 |
| GET |	/bus/timetable.do |	학내 버스 시간표 조회 |
<br>

---
## 8. 👥 역할 분배

| 역할 | 담당 영역 | 
|------|----------|
| **이영호** (조장) | 논문 검색, 취업 박람회, 주간 시간표 | 
| **김용민** (부조장) | 출결관리, 개인성적다운로드, ai봇, startcenter.jsp공지사항 ajax적용 |
| **서세민** | 이메일 전송 및 채팅, 번역 기능,  성적/졸업 증명서 출력 기능, GPA계산 기능  |
| **진주원** | 버스시간표 제작 및 버스 추천 기능 |

---

## 9. 🔑 대표 사용자 계정

| 아이디 | 비밀번호 | 닉네임 | 역할 | 이메일 |
|--------|---------|--------|------|------|
| admin1 | pass123 | 관리자1 | ADMIN | test@naver.com |
| professor1 | pass123 | 교수1 | PROFESSOR | lee@example.com |
| student1 | pass123 | 학생1 | STUDENT | hong@example.com |
