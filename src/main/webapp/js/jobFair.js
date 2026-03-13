let jobFairData = [];

/* 마감일 계산 */
function getDeadlineLabel(deadline) {

    if (!deadline) return "";

    const today = new Date();
    const endDate = new Date(deadline);

    today.setHours(0,0,0,0);
    endDate.setHours(0,0,0,0);

    if (isNaN(endDate.getTime())) return "";

    const diffTime = endDate.getTime() - today.getTime();
    const diffDay = Math.floor(diffTime / (1000 * 60 * 60 * 24));

    if (diffDay < 0) {
        return "마감";
    }

    if (diffDay === 0) {
        return "오늘 마감";
    }

    return "D-" + diffDay;
}

/* 채용공고 아이템 생성 */
function createPostingItem(posting) {

    const item = document.createElement("div");
    item.className = "posting-item";

    const headerRow = document.createElement("div");
    headerRow.className = "posting-header";

    const link = document.createElement("a");
    link.href = posting.postingUrl || "#";
    link.target = "_blank";
    link.rel = "noopener noreferrer";
    link.textContent = posting.title || "채용공고";

    headerRow.appendChild(link);

    const deadlineLabel = getDeadlineLabel(posting.deadline);

    if (deadlineLabel) {
        const badge = document.createElement("span");
        badge.className = "deadline-badge";

        if (deadlineLabel === "마감") {
            badge.classList.add("closed");
        } else if (deadlineLabel === "오늘 마감") {
            badge.classList.add("urgent");
        } else if (deadlineLabel === "D-1" || deadlineLabel === "D-2" || deadlineLabel === "D-3") {
            badge.classList.add("urgent");
        } else {
            badge.classList.add("soon");
        }

        badge.textContent = deadlineLabel;
        headerRow.appendChild(badge);
    }

    const info = document.createElement("div");
    info.className = "posting-meta";
    info.textContent =
        (posting.jobType || "") +
        ((posting.jobType && posting.deadline) ? " · " : "") +
        (posting.deadline || "");

    item.appendChild(headerRow);
    item.appendChild(info);

    return item;
}

/* 채용공고 불러오기 */
async function loadPostingList(fairNo, postingContainer) {

    try {

        const res = await fetch(contextPath + "/jobfair/postingAjax.do?fairNo=" + fairNo);
        const data = await res.json();

        if (data.error) {
            postingContainer.innerHTML = '<div class="error-message">' + data.error + '</div>';
            return;
        }

        const postingList = data.job_posting_list || [];

        if (postingList.length === 0) {
            postingContainer.innerHTML = '<div class="empty-message">등록된 채용공고가 없습니다.</div>';
            return;
        }

        const title = document.createElement("div");
        title.className = "posting-title";
        title.textContent = "최근 채용공고";

        const list = document.createElement("div");
        list.className = "posting-list";

        postingList.forEach(posting => {
            list.appendChild(createPostingItem(posting));
        });

        postingContainer.innerHTML = "";
        postingContainer.appendChild(title);
        postingContainer.appendChild(list);

    } catch (e) {

        postingContainer.innerHTML = '<div class="error-message">채용공고를 불러오는 중 오류가 발생했습니다.</div>';
        console.error(e);

    }
}

/* 카드 생성 */
function createJobFairCard(item) {

    const card = document.createElement("div");
    card.className = "jobfair-card";

    const header = document.createElement("div");
    header.className = "jobfair-header";

    const titleBox = document.createElement("div");

    const companyName = document.createElement("div");
    companyName.className = "company-name";
    companyName.textContent = item.companyName || "";

    const eventTitle = document.createElement("div");
    eventTitle.className = "event-title";
    eventTitle.textContent = item.eventTitle || "";

    titleBox.appendChild(companyName);
    titleBox.appendChild(eventTitle);

    const boothBadge = document.createElement("div");
    boothBadge.className = "booth-badge";
    boothBadge.textContent = "부스 " + (item.boothInfo || "-");

    header.appendChild(titleBox);
    header.appendChild(boothBadge);

    const info = document.createElement("div");
    info.className = "jobfair-info";

    info.innerHTML =
        "일정: " + (item.eventDate || "") + "<br>" +
        "장소: " + (item.location || "") + "<br>" +
        "주소: " + (item.address || "");

    const description = document.createElement("div");
    description.className = "jobfair-description";
    description.textContent = item.description || "";

    const actions = document.createElement("div");
    actions.className = "jobfair-actions";

    /* 지도 버튼 */
    const mapBtn = document.createElement("a");
    mapBtn.className = "jobfair-btn";
    mapBtn.href = item.mapUrl || "#";
    mapBtn.target = "_blank";
    mapBtn.rel = "noopener noreferrer";
    mapBtn.textContent = "지도 보기";

    /* 기업 홈페이지 */
    const homepageBtn = document.createElement("a");
    homepageBtn.className = "jobfair-btn";
    homepageBtn.href = item.homepageUrl || "#";
    homepageBtn.target = "_blank";
    homepageBtn.rel = "noopener noreferrer";
    homepageBtn.textContent = "기업 홈페이지";

    /* 채용 사이트 */
    const recruitBtn = document.createElement("a");
    recruitBtn.className = "jobfair-btn";
    recruitBtn.href = item.recruitUrl || "#";
    recruitBtn.target = "_blank";
    recruitBtn.rel = "noopener noreferrer";
    recruitBtn.textContent = "채용 사이트";

    /* 채용공고 토글 버튼 */
    const toggleBtn = document.createElement("button");
    toggleBtn.className = "jobfair-btn";
    toggleBtn.type = "button";
    toggleBtn.textContent = "채용공고 보기";

    actions.appendChild(mapBtn);
    actions.appendChild(homepageBtn);
    actions.appendChild(recruitBtn);
    actions.appendChild(toggleBtn);

    const postingContainer = document.createElement("div");
    postingContainer.className = "posting-container";
    postingContainer.style.display = "none";

    let isLoaded = false;
    let isOpen = false;

    toggleBtn.addEventListener("click", async function () {

        if (!isOpen) {

            postingContainer.style.display = "block";
            toggleBtn.textContent = "채용공고 숨기기";

            if (!isLoaded) {

                postingContainer.innerHTML = '<div class="loading-message">채용공고 불러오는 중...</div>';

                await loadPostingList(item.fairNo, postingContainer);

                isLoaded = true;

            }

            isOpen = true;

        } else {

            postingContainer.style.display = "none";
            toggleBtn.textContent = "채용공고 보기";

            isOpen = false;

        }

    });

    card.appendChild(header);
    card.appendChild(info);
    card.appendChild(description);
    card.appendChild(actions);
    card.appendChild(postingContainer);

    return card;
}

/* 리스트 렌더링 */
function renderJobFairList(list) {

    const listDiv = document.getElementById("jobfair-list");
    listDiv.innerHTML = "";

    if (list.length === 0) {

        listDiv.innerHTML = '<div class="empty-message">검색 결과가 없습니다.</div>';
        return;

    }

    list.forEach(item => {

        listDiv.appendChild(createJobFairCard(item));

    });

}

/* 검색 */
function filterJobFair(keyword) {

    const lowerKeyword = (keyword || "").toLowerCase();

    const filteredList = jobFairData.filter(item =>
        (item.companyName || "").toLowerCase().includes(lowerKeyword) ||
        (item.eventTitle || "").toLowerCase().includes(lowerKeyword)
    );

    renderJobFairList(filteredList);

}

/* 리스트 불러오기 */
async function loadJobFairList() {

    const listDiv = document.getElementById("jobfair-list");

    listDiv.innerHTML = '<div class="loading-message">취업박람회 정보를 불러오는 중...</div>';

    try {

        const res = await fetch(contextPath + "/jobfair/listAjax.do");

        const data = await res.json();

        if (data.error) {

            listDiv.innerHTML = '<div class="error-message">' + data.error + '</div>';
            return;

        }

        jobFairData = data.job_fair_list || [];

        if (jobFairData.length === 0) {

            listDiv.innerHTML = '<div class="empty-message">등록된 취업박람회 정보가 없습니다.</div>';
            return;

        }

        renderJobFairList(jobFairData);

    } catch (e) {

        listDiv.innerHTML = '<div class="error-message">취업박람회 정보를 불러오는 중 오류가 발생했습니다.</div>';

        console.error(e);

    }

}

/* 초기 실행 */
document.addEventListener("DOMContentLoaded", function () {

    loadJobFairList();

    const searchInput = document.getElementById("jobfair-search-input");

    if (searchInput) {

        searchInput.addEventListener("input", function () {

            filterJobFair(this.value);

        });

    }

});