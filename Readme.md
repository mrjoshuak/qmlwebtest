# Qmlweb Test

## Steps:

- 1) `$> mkdir public`
- 2) `$> npm install qmlweb`

Ok now what?  It's unclear.  The readme says **"Using one of the methods below, install the qmlweb JavaScript library"**.  Not sure
what that is supposed to be but perhaps it's `node_modules/qmlweb/lib`, so let's give that a go.

- 3) `$> cp -r node_modules/qmlweb/lib public`
- 4) Create `public/index.html` with the following:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>QML Auto-load Example</title>
  </head>
  <body style="margin: 0;" data-qml="qml/main.qml">
    <script type="text/javascript" src="/lib/qt.js"></script>
  </body>
</html>
```

- 5) `$> mkdir public/qml`
- 6) Create `public/qml/main.qml` with the following:

```qml
import QtQuick 2.0

Rectangle {
  width: 500; height: 200
  color: "lightgray"

  Text {
    id: helloText
    text: "Hello world!"
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    font.pointSize: 24; font.bold: true
  }
}
```

- 7) Open the file url for `public/index.html` fails to load `/lib/qt.js` since the path is absolute.
- 8) Either change the script source path to `src="lib/qt.js"`, or run a simple server such as `python -m SimpleHTTPServer` to server the `public` folder.

After the above modifications to the instructions it works, but it's not clear at all if this is a correct and complete installation.
Let's test to see if we can find any imports.

First let's create a separate QML for the Text Item.

- 9) Create `public/qml/HelloText.qml` with the following

```qml
import QtQuick 2.0

Text {
  color: "#f93"
  text: "Hello world!"
  anchors.verticalCenter: parent.verticalCenter
  anchors.horizontalCenter: parent.horizontalCenter
  font.pointSize: 24; font.bold: true
} 
```

I change the color so I'll be sure to see the change.

- 10) Change `public/qml/main.qml` to the following

```qml
import QtQuick 2.0

Rectangle {
  width: 500; height: 200
  color: "lightgray"

  HelloText {id: helloText}
}
```

Ok, this works, so we are able to get automatic imports.  Let's try QtQuick.Controls.

- 11) Change `public/qml/main.qml` to the following

```qml
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
```

Nope.  Doesn't work.  Nothing is rendered in the web page, and we see errors in the console:

```
Failed to load resource: the server responded with a status of 404 (file not found)      http://localhost:8000/qml/TextFile.qml
Error: No constructor found for TextField                                                construct -- qt.js:1141:83
TypeError: null is not an object (evaluating 'this.rootObject.$contenxt"                 rootContext -- qt.js:1703
TypeError: null is not an object (evaluating 'this.rootObject.$contenxt"                 rootContext -- qt.js:1703
```

Ok, so is this a bug, a known unsupported feature, or bad installation? 

### Pull Request #239
In folder `test_pr239`.  This PR seems to resolve the above issue.

Procedure:

```
$> cd test_pr239
$> git clone https://github.com/stephenmdangelo/qmlweb.git
$> cd qmlweb
$> git fetch origin pull/239/stephenmdangelo:per-import-context-constructors
$> git checkout per-import-context-constructors
$> npm install && npm run build
$> cd ..
$> cp -r qmlweb/lib public
$> cd public
$> python -m SimpleHttpServer
```
