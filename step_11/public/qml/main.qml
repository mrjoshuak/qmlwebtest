import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
  width: 500; height: 200
  color: "lightgray"

  HelloText {id: helloText}

  TextField { id: filterInput
    text: "Input"
  }
}