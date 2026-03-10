let currentPage = 0;
const resultsPerPage = 10;

function renderPagination(totalResults) {
    const resultsDiv = document.getElementById("results");
    const pagination = document.createElement("div");
    pagination.className = "pagination";

    const totalPages = Math.ceil(totalResults / resultsPerPage);

    if (currentPage > 0) {
        const prev = document.createElement("button");
        prev.type = "button";
        prev.textContent = "◀ 이전";
        prev.onclick = () => {
            currentPage--;
            search(currentPage);
        };
        pagination.appendChild(prev);
    }

    for (let i = 0; i < totalPages && i < 10; i++) {
        const btn = document.createElement("button");
        btn.type = "button";
        btn.textContent = (i + 1);
        if (i === currentPage) btn.className = "current";
        btn.onclick = () => {
            currentPage = i;
            search(currentPage);
        };
        pagination.appendChild(btn);
    }

    if (currentPage < totalPages - 1) {
        const next = document.createElement("button");
        next.type = "button";
        next.textContent = "다음 ▶";
        next.onclick = () => {
            currentPage++;
            search(currentPage);
        };
        pagination.appendChild(next);
    }

    resultsDiv.appendChild(pagination);
}

function highlightKeyword(text, keyword) {
    if (!keyword) return text;
    const escaped = keyword.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&");
    const regex = new RegExp("(" + escaped + ")", "gi");
    return text.replace(regex, "<strong>$1</strong>");
}

function createResultCard(item, keyword) {
	const card = document.createElement("div");
	card.className = "result-card";

	const link = document.createElement("a");
	link.href = item.link || "#";
	link.target = "_blank";
	link.rel = "noopener noreferrer";
	link.innerHTML = highlightKeyword(item.title || "", keyword);

	const info = document.createElement("div");
	info.className = "result-info";

	const authors = item.publication_info?.authors || "";
	const year = item.publication_info?.year || "";
	const infoText = authors + (authors && year ? " · " : "") + year;
	info.innerHTML = highlightKeyword(infoText, keyword);

	const snippet = document.createElement("div");
	snippet.className = "result-snippet";
	snippet.innerHTML = highlightKeyword(item.snippet || "", keyword);

	card.appendChild(link);

	const header = document.createElement("div");
	header.className = "result-header";

	header.appendChild(link);

	if (item.pdf_link) {
	    const pdfLink = document.createElement("a");
	    pdfLink.href = item.pdf_link;
	    pdfLink.target = "_blank";
	    pdfLink.rel = "noopener noreferrer";
	    pdfLink.className = "pdf-link";
	    pdfLink.textContent = "PDF";

	    header.appendChild(pdfLink);
	}

	card.appendChild(header);
	card.appendChild(info);
	card.appendChild(snippet);

	const actionRow = document.createElement("div");
	actionRow.className = "citation-row";

	let hasAction = false;

	if (item.cited_by && item.cited_by > 0) {
	    const citedLink = document.createElement("a");
	    citedLink.href = item.cited_link || "#";
	    citedLink.target = "_blank";
	    citedLink.rel = "noopener noreferrer";
	    citedLink.textContent = "Cited by " + item.cited_by;

	    actionRow.appendChild(citedLink);
	    hasAction = true;
	}

	if (item.related_link) {
	    if (hasAction) {
	        const separator = document.createElement("span");
	        separator.className = "action-separator";
	        separator.textContent = "  ";
	        actionRow.appendChild(separator);
	    }

	    const relatedLink = document.createElement("a");
	    relatedLink.href = item.related_link;
	    relatedLink.target = "_blank";
	    relatedLink.rel = "noopener noreferrer";
	    relatedLink.textContent = "Related articles";

	    actionRow.appendChild(relatedLink);
	    hasAction = true;
	}

	if (hasAction) {
	    card.appendChild(actionRow);
	}
	
	return card;
}

async function search(page = 0) {
    const q = document.getElementById("search-input").value.trim();
    const author = document.getElementById("author-input").value.trim();
    const year = document.getElementById("year-input").value.trim();
    const site = document.getElementById("site-input").value.trim();
    const sort = document.getElementById("sort-select").value;

    const resultsDiv = document.getElementById("results");
    resultsDiv.innerHTML = "";

    if (!q) {
        resultsDiv.innerHTML = '<div class="error-message">검색어를 입력해주세요.</div>';
        return;
    }

    const params = new URLSearchParams({
        q: q,
        author: author,
        year: year,
        site: site,
        sort: sort,
        start: page * resultsPerPage
    });

    try {
        const res = await fetch(contextPath + "/scholar/searchAjax.do?" + params.toString());
        const data = await res.json();

        if (data.error) {
            resultsDiv.innerHTML = '<div class="error-message">' + data.error + '</div>';
            return;
        }

        if (data.organic_results && data.organic_results.length > 0) {
            data.organic_results.forEach(item => {
                const card = createResultCard(item, q);
                resultsDiv.appendChild(card);
            });

            renderPagination(data.search_information?.total_results || 0);
        } else {
            resultsDiv.innerHTML = '<div class="no-result">검색 결과가 없습니다.</div>';
        }
    } catch (e) {
        resultsDiv.innerHTML = '<div class="error-message">검색 중 오류가 발생했습니다.</div>';
        console.error(e);
    }
}

document.addEventListener("DOMContentLoaded", function () {
    const searchBtn = document.getElementById("search-btn");
    const searchInput = document.getElementById("search-input");

    if (searchBtn) {
        searchBtn.addEventListener("click", function () {
            currentPage = 0;
            search(currentPage);
        });
    }

    if (searchInput) {
        searchInput.addEventListener("keydown", function (e) {
            if (e.key === "Enter") {
                currentPage = 0;
                search(currentPage);
            }
        });
    }
});