function startTime() {
    var today = new Date();
    var h = today.getHours();
    var m = today.getMinutes();
    var s = today.getSeconds();
    var ampm = h >= 12 ? 'PM' : 'AM';

    // Convertir a formato de 12 horas
    h = h % 12;
    h = h ? h : 12; // La hora '0' debe ser '12'

    m = checkTime(m);
    s = checkTime(s);

    var timeMin = document.getElementById("time-min")
    var timeSec = document.getElementById("time-sec")
    var timeHour = document.getElementById("time-hours")
    var timeDate = document.getElementById("time-date")

    if (timeHour) {
        timeHour.innerHTML = h;
    }
    if (timeMin) {
        timeMin.innerHTML = m;
    }
    if (timeSec) {
        timeSec.innerHTML = s + ' ' + ampm; // Agregar AM/PM después de los segundos
    }
    if (timeDate) {
        var days = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];
        var months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
        var dayName = days[today.getDay()];
        var day = today.getDate();
        var monthName = months[today.getMonth()];
        var year = today.getFullYear();
        timeDate.innerHTML = dayName + ' ' + day + ' ' + monthName + ' ' + year;
    }
    var t = setTimeout(startTime, 500);
}
function checkTime(i) {
    if (i < 10) { i = "0" + i };  // add zero in front of numbers < 10
    return i;
}
startTime()
