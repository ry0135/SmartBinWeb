console.log("Opening Web Socket from websocket.js...");

var socket = new SockJS('https://smartbinx.duckdns.org/ws-bin-sockjs');
let stompClient = Stomp.over(socket);

// ================= CONNECT ==================
stompClient.connect({}, function(frame) {

    console.log("✅ WS CONNECTED:", frame);

    // ==================== BIN UPDATES ====================
    stompClient.subscribe('/topic/binUpdates', function (message) {
        const bin = JSON.parse(message.body);
        console.log("📦 BIN UPDATE:", bin);

        if (typeof updateBinRow === 'function') updateBinRow(bin);
        if (typeof updateBinMarker === 'function') updateBinMarker(bin);
    });

    // ==================== BIN REMOVED ====================
    stompClient.subscribe('/topic/binRemoved', function (message) {
        const data = JSON.parse(message.body);
        console.log("🗑 BIN REMOVED:", data);

        if (typeof removeBinRow === 'function') removeBinRow(data.binID);
        if (typeof removeBinMarker === 'function') removeBinMarker(data.binID);

        showNotificationPopup("⚠️ Thùng rác đã xóa",
            `Mã: ${data.binCode || data.binID}`);
    });

    // ================= REPORT UPDATES =================
    stompClient.subscribe('/topic/report-updates', function(message) {
        const report = JSON.parse(message.body);
        console.log("📢 REPORT:", report);

        const binCode = report.bin?.binCode || "BIN#" + report.binId;

        showNotificationPopup(
            "📢 Báo cáo mới",
            `Thùng: ${binCode}<br>${report.description}`
        );

        updateNotificationBadge();
    });

    // ================= TASK UPDATES =================
    stompClient.subscribe("/topic/task-updates", function(message) {

        console.log("📌 TASK UPDATE:", message.body);
        const update = JSON.parse(message.body);

        // ✅ Kiểm tra tasks có tồn tại và có phần tử không
        if (!update.tasks || update.tasks.length === 0) {
            console.warn("⚠️ Không có tasks trong update:", update);

            // Xử lý trường hợp chỉ có batchId và status
            if (update.batchId && update.status) {
                console.log(`Batch ${update.batchId} đang ở trạng thái: ${update.status}`);
            }
            return; // Dừng xử lý
        }

        const tasks = update.tasks;
        const status = update.status;
        const task = tasks[0];

        const binCode = task.bin?.binCode || ("BIN#" + task.binId);
        const batchId = task.batchId;

        if (status === "COMPLETED") {
            showNotificationPopup(
                "🎉 Hoàn thành nhiệm vụ",
                `<b>${task.assignedToName}</b> đã hoàn thành<br>Batch: ${batchId}<br>Thùng: ${binCode}`
            );
        }
        if (status === "DOING") {
            showNotificationPopup(
                "🚀 Nhận nhiệm vụ",
                `<b>${task.assignedToName}</b> đã nhận nhiệm vụ<br>Batch: ${batchId}`
            );
        }
        if (status === "CANCELLED") {
            showNotificationPopup(
                "⚠️ Hủy nhiệm vụ",
                `<b>${task.assignedToName}</b> đã hủy nhiệm vụ<br>Batch: ${batchId}`
            );
        }
        if (status === "ISSUE") {
            showNotificationPopup(
                "❗ Sự cố nhiệm vụ",
                `<b>${task.assignedToName}</b> báo sự cố<br>Batch: ${batchId}`
            );
        }

        updateNotificationBadge();
    });

}, function(error) {
    console.error("❌ STOMP ERROR:", error);
    setTimeout(() => location.reload(), 3000);
});

console.log("✅ WebSocket script loaded");


// ================= HELPER FUNCTIONS =================
function updateNotificationBadge() {
    const badge = document.querySelector('#btnNotification .badge');
    if (badge) {
        let count = Number(badge.textContent) || 0;
        badge.textContent = count + 1;
        badge.style.display = 'inline-block';
    }
}

function addNotificationToDropdown(report) {
    const list = document.getElementById('notificationList');
    if (!list) return;

    const html = `
        <div class="d-flex align-items-start py-2 border-bottom noti-item" data-read="false">
            <div class="me-2"><span class="badge bg-warning text-dark">!</span></div>
            <div class="flex-grow-1">
                <div class="fw-semibold">Báo cáo mới</div>
                <div class="text-muted small">${report.description}</div>
                <div class="text-muted small">${new Date().toLocaleString()}</div>
            </div>
            <span class="ms-2" style="color:#0d6efd;">●</span>
        </div>`;
    list.insertAdjacentHTML('afterbegin', html);
}

console.log("✅ WebSocket script loaded");
