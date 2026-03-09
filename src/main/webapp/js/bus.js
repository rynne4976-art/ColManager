let busRoutes = [];
let busSchedule = [];

document.addEventListener("DOMContentLoaded", function() {

	loadBusData();

});

async function loadBusData() {

	const SERVICE_KEY = "b48401cf98b243db75c7cef7d1948f3b684ace34b5adddefb9e5bd1c65665482";

	const url = "https://api.odcloud.kr/api/3079310/v1/uddi:4eccd3ef-d4ab-4706-bbb9-dad3edd62833_201905271750?page=1&perPage=100&returnType=JSON&serviceKey=" + SERVICE_KEY;

	try {

		const res = await fetch(url);
		const data = await res.json();

		busRoutes = data.data.map(row => {

			return {

				route: row["노선번호"],
				start: row["기점"],
				end: row["종점"],
				first: "08:00",
				last: "20:00",
				interval: 20

			};

		});

		generateTimetable();

	} catch (e) {

		console.log("버스 데이터 로딩 실패", e);

	}

}


function generateTimetable() {

	busSchedule = [];

	busRoutes.forEach(route => {

		let time = route.first;

		while (time <= route.last) {

			busSchedule.push({

				route: route.route,
				time: time

			});

			time = addMinutes(time, route.interval);

		}

	});

	renderBusTable();

}


function renderBusTable() {

	let grouped = {};

	busSchedule.forEach(bus => {

		if (!grouped[bus.time]) grouped[bus.time] = [];

		if (grouped[bus.time].length < 3) {

			grouped[bus.time].push(bus.route);

		}

	});

	const times = Object.keys(grouped);

	const half = Math.ceil(times.length / 2);

	const left = times.slice(0, half);
	const right = times.slice(half);

	let html = "";

	for (let i = 0; i < half; i++) {

		const t1 = left[i];
		const r1 = grouped[t1] || [];

		const t2 = right[i];
		const r2 = grouped[t2] || [];

		html += `
        <tr>

            <td>${t1 || ""}</td>
            <td>${makeRouteTags(r1)}</td>

            <td>${t2 || ""}</td>
            <td>${makeRouteTags(r2)}</td>

        </tr>
        `;

	}

	document.getElementById("busTableBody").innerHTML = html;

}


function makeRouteTags(routes) {

	let html = "";

	routes.forEach(r => {

		html += `<span class="route-tag">🚌 ${r}</span>`;

	});

	return html;

}


function recommendBus() {

	const endTime = document.getElementById("classEndTime").value;

	if (!endTime) {

		alert("수업 종료시간 입력");
		return;

	}

	const targetTime = addMinutes(endTime, 10);

	let closest = null;

	busSchedule.forEach(bus => {

		if (bus.time >= targetTime) {

			if (!closest || bus.time < closest.time) {

				closest = bus;

			}

		}

	});

	if (closest) {

		document.getElementById("recommendArea").innerHTML =

			`<div class="recommend-box">
        추천 버스 → ${closest.time} 🚌 ${closest.route}
        </div>`;

	}

}


function addMinutes(time, minutes) {

	let parts = time.split(":");

	let date = new Date();

	date.setHours(parts[0]);
	date.setMinutes(parts[1]);

	date.setMinutes(date.getMinutes() + minutes);

	let h = String(date.getHours()).padStart(2, "0");
	let m = String(date.getMinutes()).padStart(2, "0");

	return h + ":" + m;

}