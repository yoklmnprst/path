## Application Description

[rus version](README.ru.md)

This application has the following functional capabilities:

1. **Input Points**. On the first screen, the user has the ability to enter a certain number of points.

2. **Loading and Displaying Points**. After entering the points, data is loaded over the network, and then the points are displayed on the next screen.

> Note: The network part has been mocked to allow the application to run without a configured backend, but the network stack is fully functional.

[video demonstration](https://github.com/yoklmnprst/path/assets/52455150/c891a85f-5dd7-4d8d-8251-9b5e07b063e5)


## Features and Supported Features

1. SwiftUI iOS 15.0+

2. Written from scratch without the use of third-party libraries and external dependencies.

3. Examples of writing Unit tests are provided (PointService classes, HTTPRequester, including the view model - InputPoints).

4. Handling of network disconnection, interruption, timeout, and backend errors.

5. Localization in English and Russian languages.

6. Support for landscape mode.

7. For pinch + pan gestures (when viewing points on the graph), input data obtained from UIScrollView is [used through UIViewRepresentable](Path/DisplayPointsView/HorizontalPanPinch.swift). However, the drawing is implemented through SwiftUI.


## Component Graph
```
MainScene
└── TwoSceneNavigation    ──   ProcessPoints
    ├── InputPointsView   ──   ├── InputPoints 
    └── DisplayPointsView ──   └── DisplayPoints

InputPoints ── PointService ── HTTPRequester ── URLSession
```

InputPoints is responsible for inputting points.
DisplayPoints is responsible for displaying points.
ProcessPoints is the coordination part between the two screens.
