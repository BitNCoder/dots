pragma Singleton

import Quickshell
import QtQuick


Scope {
    id: root
    property string format: "ddd MMMM d hh:mm:ss AP t yyyy"

    readonly property string time: {
	// Qt.formatDateTime(clock.date, "ddd MMMM d hh:mm:ss AP t yyyy");
	Qt.formatDateTime(clock.date, format);
    }

    SystemClock {
	id: clock
	precision: SystemClock.Seconds
    }
}
