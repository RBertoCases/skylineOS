import QtQuick 2.8
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0
import "../utils.js" as Utils

FocusScope {
  id: root
  property bool showBack: true
  property bool showCollControls: false
  property bool showFav: true
  property var gameData: softwareList[sortByIndex].currentGame(currentScreenID)
  property string collectionShortName: Utils.processPlatformName(currentGame.collections.get(0).shortName)

  function processButtonArt(buttonModel) {
    var i;
    for (i = 0; buttonModel.length; i++) {
      if (buttonModel[i].name().includes("Gamepad")) {
        var buttonValue = buttonModel[i].key.toString(16)
        return buttonValue.substring(buttonValue.length-1, buttonValue.length);
      }
    }
  }

  Item {
    id: background

    width: parent.width
    height: parent.height

    Behavior on opacity { NumberAnimation { duration: 200 }}

    Image {
      id: controllerIcon
      width: vpx(80)
      height: vpx(70)
      horizontalAlignment: Image.AlignLeft
      fillMode: Image.PreserveAspectFit
      source: collectionShortName ? "../assets/images/controllers/" + collectionShortName + ".svg" : "../assets/images/controllers/switch.svg"
      visible: false

      anchors {
        verticalCenter: parent.verticalCenter
        left: parent.left
        leftMargin: vpx(25)
      }
    }

    ColorOverlay {
      anchors.fill: controllerIcon
      source: controllerIcon
      color: theme.text
      smooth: true
      cached: true
    }

    RowLayout {
      anchors {
        verticalCenter: parent.verticalCenter
        right: parent.right
      }
      spacing: vpx(25)
      layoutDirection: Qt.RightToLeft

      ControllerHelpButton {
        id: buttonOK
        button: processButtonArt(api.keys.accept)
        label: 'OK'
        Layout.fillWidth: true
        Layout.minimumWidth: vpx(50)
        Layout.preferredWidth: vpx(60)

        onClicked: {}

      }

      ControllerHelpButton {
        id: buttonBack
        button: processButtonArt(api.keys.cancel)
        label: 'Back'
        Layout.fillWidth: true
        Layout.minimumWidth: vpx(50)
        Layout.preferredWidth: vpx(75)

        onClicked: { showHomeScreen(); }

        visible: showBack
      }

      ControllerHelpButton {
          id: buttonFavorite
          button: processButtonArt(api.keys.details)
          label: "Fav"
          Layout.fillWidth: true
          Layout.minimumWidth: vpx(50)
          Layout.preferredWidth: vpx(50)

          onClicked: {}
          visible: showFav
      }

      ControllerHelpButton {
        id: buttonNext
        button: processButtonArt(api.keys.nextPage)
        label: 'Next Collection'
        Layout.fillWidth: true
        Layout.minimumWidth: vpx(175)
        Layout.preferredWidth: widescreen ? vpx(175) : vpx(212)

        onClicked: {
          turnOnSfx.play();
          if (currentCollection < api.collections.count-1) {
              nextCollection++;
          } else {
              nextCollection = -1;
          }
        }

        visible: showCollControls
      }

      //Previous Collection Button
      ControllerHelpButton {
        id: buttonPrev
        button: processButtonArt(api.keys.prevPage)
        label: 'Prev Collection'
        Layout.fillWidth: true
        Layout.minimumWidth: vpx(130)
        Layout.preferredWidth: vpx(175)

        onClicked: {
          turnOffSfx.play();
          if (currentCollection == -1) {
            nextCollection = api.collections.count-1;
          } else{ 
            nextCollection--;
          }
        }

        visible: showCollControls
      }

    }

  }//background
}//root
