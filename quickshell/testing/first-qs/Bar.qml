import Quickshell
import QtQuick
import Quickshell.Hyprland

LazyLoader{
    active: Hyprland.focusedWorkspace.name != "zen" // compatability with goto_zen.sh
    Variants {
	model: Quickshell.screens

	PanelWindow {
	    required property var modelData
	    screen: modelData

	    anchors {
		top: true
		left: true
		right: true
	    }
	    color: "transparent"

	    implicitHeight: 30

	    Rectangle {
		id: clock1
		anchors {
		    top: parent.top
		    right: parent.right
		    bottom: parent.bottom

		    rightMargin: 5
		}
		implicitWidth: screen.width / 5 
		color: "plum"

		// topRightRadius: 10
		bottomLeftRadius: 10
		bottomRightRadius: 10



		ClockWidget {
		    anchors.centerIn: parent
		}
	    }

	    Rectangle {
		anchors {
		    top: parent.top
		    right: clock1.left
		    bottom: parent.bottom

		    rightMargin: 5
		}
		implicitWidth: screen.width / 5
		color: "orchid"

		PowerWidget {
		    anchors.centerIn: parent
		}
	    }
	}
    }
}
