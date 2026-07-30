import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets


Scope {
    id: root

    PwObjectTracker {
	objects: [ Pipewire.defaultAudioSink ]
    }

    Connections {
	target: Pipewire.defaultAudioSink?.audio

	function onVolumeChanged() {
	    root.shouldShowOsd = true;
	    hideTimer.restart();
	}
    }

    property bool shouldShowOsd: false

    Timer {
	id: hideTimer
	interval: 1000
	onTriggered: root.shouldShowOsd = false
    }


    // The OSD window will be created and destroyed based on shouldShowOsd
    LazyLoader {
	active: root.shouldShowOsd


	PanelWindow {
	    anchors.bottom: true
	    margins.bottom: screen.height - (screen.height / 8)
	    exclusiveZone: 0

	    implicitWidth: 400
	    implicitHeight: 50
	    color: "transparent"

	    // an empty mask that prevents the window from blocking mouse movements
	    mask: Region {}

	    Rectangle {
		anchors.fill: parent
		radius: height / 2
		color: "#80000000"

		RowLayout {
		    anchors {
			fill: parent
			leftMargin: 10
			rightMargin: 15
		    }

		    IconImage {
			implicitSize: 30
			source: Quickshell.iconPath("audio-volume-high-symbolic")
		    }

		    Rectangle {
			// Stretches to fill all leftover space
			Layout.fillWidth: true

			implicitHeight: 10
			radius: 20
			color: "#50000000"

			Rectangle {
			    anchors {
				left: parent.left
				top: parent.top
				bottom: parent.bottom
			    }

			    implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
			    radius: parent.radius
			}
		    }
		}
	    }
	}
    }
}
