let busList = []

window.addEventListener("DOMContentLoaded", function() {

	fetch(contextPath + "/bus")
		.then(res => res.json())
		.then(data => {

		    busList = data.schedule

		    renderTable(busList)

		    initBuildings(data.buildings)

		})

})

/* 시간표 출력 */

function renderTable(data) {

	let tbody = document.getElementById("busTableBody")

	tbody.innerHTML = ""

	for (let i = 0; i < data.length; i += 2) {

		let row = document.createElement("tr")

		let b1 = data[i]
		let b2 = data[i + 1]

		let html =
			`<td>${b1.time}</td>
         <td>${b1.route}</td>`

		if (b2) {

			html +=
				`<td>${b2.time}</td>
             <td>${b2.route}</td>`

		} else {

			html += "<td></td><td></td>"

		}

		row.innerHTML = html

		tbody.appendChild(row)

	}

}

/* 건물 목록 생성 */

function initBuildings(buildings) {

	let startSel = document.getElementById("startBuilding")
	let endSel = document.getElementById("endBuilding")

	buildings.forEach(b => {

		startSel.innerHTML += `<option value="${b}">${b}</option>`
		endSel.innerHTML += `<option value="${b}">${b}</option>`

	})

}


/* 시간 → 분 */

function toMin(t) {

	let [h, m] = t.split(":").map(Number)

	return h * 60 + m

}

/* 추천 버스 */

function recommendBus() {

	let start = document.getElementById("startBuilding").value
	let end = document.getElementById("endBuilding").value
	let endTime = document.getElementById("classEndTime").value

	if (!start || !end || !endTime) {

		alert("모든 값을 입력하세요.")
		return

	}

	if (start === end) {

		alert("출발과 도착 건물이 같습니다.")
		return

	}

	/* 종료시간 +10분 */

	let target = toMin(endTime) + 10

	let best = null

	for (let bus of busList) {

		if (bus.start === start && bus.end === end) {

			if (toMin(bus.time) >= target) {

				best = bus
				break

			}

		}

	}

	renderRecommend(best)

}


/* 추천 카드 */

function renderRecommend(bus) {

	let area = document.getElementById("recommendArea")

	if (!bus) {

		area.innerHTML = "<div class='no-bus'>이용 가능한 버스가 없습니다.</div>"
		return

	}

	let depart = bus.time
	let arrive = bus.arrive

	let duration = toMin(arrive) - toMin(depart)

	area.innerHTML = `

    <div class="recommend-card">

        <div class="recommend-header">
            🚌 추천 버스
        </div>

        <div class="recommend-bus">
            ${bus.route}
        </div>

        <div class="route-box">

            <div class="route-point">
                <div class="route-label">출발</div>
                <div class="route-building">${bus.start}</div>
            </div>

            <div class="route-time">
                ${depart} → ${arrive}
            </div>

            <div class="route-point">
                <div class="route-label">도착</div>
                <div class="route-building">${bus.end}</div>
            </div>

        </div>

        <div class="duration-box">
            소요시간 : ${duration}분
        </div>

        <div class="arrival-box">
            도착 예상 : ${arrive}
        </div>

    </div>

    `

}