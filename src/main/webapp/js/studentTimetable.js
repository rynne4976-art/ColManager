document.addEventListener("DOMContentLoaded", function () {
    const dayMap = {
        1: "MON",
        2: "TUE",
        3: "WED",
        4: "THU",
        5: "FRI"
    };

    const today = new Date();
    const todayDayNumber = today.getDay(); // 일:0, 월:1, ... 토:6
    const todayKey = dayMap[todayDayNumber];

    highlightTodayColumn(todayKey);

    fetch(contextPath + "/classroom/studentTimetableData.do")
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            const emptyMessage = document.getElementById("timetable-empty-message");

            if (!data || data.length === 0) {
                if (emptyMessage) {
                    emptyMessage.style.display = "block";
                    emptyMessage.innerText = "현재 표시할 시간표가 없습니다.";
                }
                return;
            }

            if (emptyMessage) {
                emptyMessage.style.display = "none";
            }

            data.forEach(function(item) {
                const cellId = item.day + "_" + item.period;
                const cell = document.getElementById(cellId);

                if (cell) {
                    cell.innerHTML =
                        "<div class='subject'>" + item.subject + "</div>" +
                        "<div class='room'>" + item.room + "</div>" +
                        "<div class='professor'>" + item.professor + "</div>";

                    // 오늘 요일에 실제 수업이 있는 칸 강조
                    if (todayKey && item.day === todayKey) {
                        cell.classList.add("today-has-class");
                    }
                }
            });

            // 선택: 현재 교시 칸까지 더 강조하고 싶으면 사용
            highlightCurrentPeriod(todayKey);
        })
        .catch(function(error) {
            console.error("시간표 불러오기 실패:", error);

            const emptyMessage = document.getElementById("timetable-empty-message");
            if (emptyMessage) {
                emptyMessage.style.display = "block";
                emptyMessage.innerText = "시간표를 불러오지 못했습니다.";
            }
        });
});

function highlightTodayColumn(todayKey) {
    if (!todayKey) {
        return;
    }

    const header = document.querySelector('.day-header[data-day="' + todayKey + '"]');
    if (header) {
        header.classList.add("today-header");
    }

    const todayCells = document.querySelectorAll('.timetable-cell[data-day="' + todayKey + '"]');
    todayCells.forEach(function(cell) {
        cell.classList.add("today-column");
    });
}

function highlightCurrentPeriod(todayKey) {
    if (!todayKey) {
        return;
    }

    const currentPeriod = getCurrentPeriod();
    if (!currentPeriod) {
        return;
    }

    const currentCell = document.getElementById(todayKey + "_" + currentPeriod);
    if (currentCell && currentCell.innerHTML.trim() !== "") {
        currentCell.classList.add("current-class");
    }
}

function getCurrentPeriod() {
    const now = new Date();
    const hour = now.getHours();
    const minute = now.getMinutes();
    const currentTime = hour * 60 + minute;

    // 필요하면 학교 시간표 기준으로 바꿔도 됨
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