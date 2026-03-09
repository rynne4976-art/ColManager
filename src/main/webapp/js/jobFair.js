function createPostingItem(posting) {
    const item = document.createElement("div");
    item.className = "posting-item";

    const link = document.createElement("a");
    link.href = posting.postingUrl || "#";
    link.target = "_blank";
    link.rel = "noopener noreferrer";
    link.textContent = posting.title || "채용공고";

    const info = document.createElement("div");
    info.textContent =
        (posting.jobType || "") +
        ((posting.jobType && posting.deadline) ? " · " : "") +
        (posting.deadline || "");

    item.appendChild(link);
    item.appendChild(info);

    return item;
}

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

    const mapBtn = document.createElement("a");
    mapBtn.className = "jobfair-btn";
    mapBtn.href = item.mapUrl || "#";
    mapBtn.target = "_blank";
    mapBtn.rel = "noopener noreferrer";
    mapBtn.textContent = "지도 보기";

    const homepageBtn = document.createElement("a");
    homepageBtn.className = "jobfair-btn";
    homepageBtn.href = item.homepageUrl || "#";
    homepageBtn.target = "_blank";
    homepageBtn.rel = "noopener noreferrer";
    homepageBtn.textContent = "기업 홈페이지";

    const recruitBtn = document.createElement("a");
    recruitBtn.className = "jobfair-btn";
    recruitBtn.href = item.recruitUrl || "#";
    recruitBtn.target = "_blank";
    recruitBtn.rel = "noopener noreferrer";
    recruitBtn.textContent = "채용공고";

    actions.appendChild(mapBtn);
    actions.appendChild(homepageBtn);
    actions.appendChild(recruitBtn);

    const postingContainer = document.createElement("div");
    postingContainer.className = "posting-container";
    postingContainer.innerHTML = '<div class="loading-message">채용공고 불러오는 중...</div>';

    card.appendChild(header);
    card.appendChild(info);
    card.appendChild(description);
    card.appendChild(actions);
    card.appendChild(postingContainer);

    loadPostingList(item.fairNo, postingContainer);

    return card;
}

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

        const jobFairList = data.job_fair_list || [];
        listDiv.innerHTML = "";

        if (jobFairList.length === 0) {
            listDiv.innerHTML = '<div class="empty-message">등록된 취업박람회 정보가 없습니다.</div>';
            return;
        }

        jobFairList.forEach(item => {
            listDiv.appendChild(createJobFairCard(item));
        });

    } catch (e) {
        listDiv.innerHTML = '<div class="error-message">취업박람회 정보를 불러오는 중 오류가 발생했습니다.</div>';
        console.error(e);
    }
}

document.addEventListener("DOMContentLoaded", function () {
    loadJobFairList();
});