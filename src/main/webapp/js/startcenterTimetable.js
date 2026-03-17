document.addEventListener("DOMContentLoaded", function() {
    const dayMap = {
        1: "MON",
        2: "TUE",
        3: "WED",
        4: "THU",
        5: "FRI"
    };

    const today = new Date();
    const todayKey = dayMap[today.getDay()];

    highlightMiniTodayColumn(todayKey);

    fetch(contextPath + "/classroom/studentTimetableMiniData.do")
        .then(response => response.json())
        .then(data => {
            const emptyMessage = document.getElementById("mini-timetable-empty-message");

            if (!data || data.length === 0) {
                if (emptyMessage) {
                    emptyMessage.style.display = "block";
                    emptyMessage.innerText = "표시할 시간표가 없습니다.";
                }
                return;
            }

            if (emptyMessage) {
                emptyMessage.style.display = "none";
                emptyMessage.innerText = "";
            }

            data.forEach(item => {
                const cellId = "mini_" + item.day + "_" + item.period;
                const cell = document.getElementById(cellId);

                if (cell) {
                    cell.innerHTML =
                        "<div class='mini-subject'>" + item.subject + "</div>";

                    if (todayKey && item.day === todayKey) {
                        cell.classList.add("today-has-class");
                    }
                }
            });

            highlightMiniCurrentPeriod(todayKey);
        })
        .catch(error => {
            console.error("미니 시간표 로딩 실패:", error);

            const emptyMessage = document.getElementById("mini-timetable-empty-message");
            if (emptyMessage) {
                emptyMessage.style.display = "block";
                emptyMessage.innerText = "시간표를 불러오지 못했습니다.";
            }
        });
});

function highlightMiniTodayColumn(todayKey) {
    if (!todayKey) {
        return;
    }

    const header = document.querySelector('.mini-day-header[data-day="' + todayKey + '"]');
    if (header) {
        header.classList.add("today-header");
    }

    const todayCells = document.querySelectorAll('.mini-cell[data-day="' + todayKey + '"]');
    todayCells.forEach(cell => {
        cell.classList.add("today-column");
    });
}

function highlightMiniCurrentPeriod(todayKey) {
    if (!todayKey) {
        return;
    }

    const currentPeriod = getMiniCurrentPeriod();
    if (!currentPeriod) {
        return;
    }

    const currentCell = document.getElementById("mini_" + todayKey + "_" + currentPeriod);
    if (currentCell && currentCell.innerHTML.trim() !== "") {
        currentCell.classList.add("current-class");
    }
}

function getMiniCurrentPeriod() {
    const now = new Date();
    const currentTime = now.getHours() * 60 + now.getMinutes();

    const periodTimes = [
        { period: 1, start: 9 * 60, end: 10 * 60 },
        { period: 2, start: 10 * 60, end: 11 * 60 },
        { period: 3, start: 11 * 60, end: 12 * 60 },
        { period: 4, start: 12 * 60, end: 13 * 60 },
        { period: 5, start: 13 * 60, end: 14 * 60 },
        { period: 6, start: 14 * 60, end: 15 * 60 },
        { period: 7, start: 15 * 60, end: 16 * 60 },
        { period: 8, start: 16 * 60, end: 17 * 60 },
        { period: 9, start: 17 * 60, end: 18 * 60 }
    ];

    for (let i = 0; i < periodTimes.length; i++) {
        if (currentTime >= periodTimes[i].start && currentTime < periodTimes[i].end) {
            return periodTimes[i].period;
        }
    }

    return null;
}