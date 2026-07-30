pragma Singleton

import Quickshell
import QtQuick
import QtQml
import Quickshell.Services.UPower

Scope {
    id: root
    readonly property var chargeState: UPower.displayDevice.state
    readonly property bool isCharging: chargeState == UPowerDeviceState.Charging
    readonly property bool isPluggedin: isCharging || chargeState == UPowerDeviceState.PendingCharge
    readonly property real timeToEmpty: UPower.displayDevice.timeToEmpty
    readonly property real timeToFull: UPower.displayDevice.timeToFull
    readonly property real percentage: UPower.displayDevice.percentage



    readonly property string batteryText: {
	let str = "BAT: ";
	str += percentage * 100 + "% ";
	let time = isCharging ? timeToFull : timeToEmpty;
	str += (isCharging ? "chrg" : "dchrg") + " ";
	str += Qt.formatTime(new Date(0,0,0,0,0,time), "hh:mm:ss");

	return str;
    }
}
