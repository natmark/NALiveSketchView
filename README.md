<img src="https://github.com/natmark/NALiveSketchView/blob/master/Assets/livesketch.png?raw=true" width="60%" height="60%"></img>
# NALiveSketchView
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## About
Live camera view with drawable view.

## Screenshot
<img src="https://github.com/natmark/NALiveSketchView/blob/master/Assets/screen_sample.png?raw=true" width="50%" height="50%"></img>

## Usage
```Swift
  lazy var sketchView:NALiveSketchView = {
        return NALiveSketchView(frame: frame)
    }()
```

### Usage with Storyboard
Connect the UIView to NALiveSketchView Class 
![](https://github.com/natmark/NALiveSketchView/blob/master/Assets/storyboard_usage.png?raw=true)

```Swift
 @IBOutlet weak var liveSketchView: NALiveSketchView!
```

## Take Sketch Photo
You can get image that combined photo and sketch.
```Swift
  func takeSketchPhoto(completionHandler: @escaping (_ image: UIImage) -> ())
```

## Options
You can set drawableView options.

- `liveSketchView.drawableView.penColor = UIColor.black`

To change drawing color, just set **penColor** parameter.

- `liveSketchView.drawableView.penMode = .pen`

To switch penMode, just set **penMode** parameter.

```Swift
public enum NAPenMode {
    case pen
    case eraser
}
```

## Instration
### [Carthage](https://github.com/Carthage/Carthage)
Add this to `Cartfile`
```
github "natmark/NALiveSketchView" ~> 0.1
```

## Author
[natmark](https://github.com/natmark)

## License
NALiveSketchView is available under the MIT license. See the LICENSE file for more info.
