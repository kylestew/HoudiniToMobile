import SwiftUI
import SceneKit
import SceneKit.ModelIO

struct ContentView: View {

    @State private var sunlightSwitch = true
    @State private var cameraSwitch = true
    @State private var povName = "distantCamera"
    @State private var magnification = CGFloat(1.0)
    @State private var isDragging = false
    @State private var totalChangePivot = SCNMatrix4Identity

    private var scene = SCNScene(
        named: "art.scnassets/bunny.scn"
    )!

//    private var scene: SCNScene!

    init() {
//        let url = Bundle.main.url(forResource: "bunny", withExtension: "scn")!
//        let mdlAsset = MDLAsset(url: url)
//        let scene = SCNScene(mdlAsset: mdlAsset)
//        self.scene = scene

//        let thing = scene.rootNode.childNode(withName: povName, recursively: true)!

//        thing.camera?.wantsDepthOfField = true
//        thing.camera?.focusDistance = 0.8
//        thing.camera?.fStop = 5.6
//        thing.camera?.wantsHDR = true

//        thing.camera?.motionBlurIntensity = 1.0

//        thing.camera?.screenSpaceAmbientOcclusionIntensity = 1.0
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if let scene = scene {
                SceneView(
                    scene: scene,
                    pointOfView: scene.rootNode.childNode(withName: povName, recursively: true),
                    options: [.allowsCameraControl]
//                    antialiasingMode: .none
                )
            }

            VStack {
                Text("Hello, SwiftUI!")
                    .multilineTextAlignment(.leading)
                    .padding()
                    .foregroundColor(.gray)
                    .font(.largeTitle)

                Text("And SceneView too")
                    .foregroundColor(.gray)
                    .font(.title2)

                Spacer(minLength: 300)

                HStack(spacing: 5) {
                    Button(action: {
                        withAnimation {
                            self.sunlightSwitch.toggle()
                        }

                        let sunlight = self.scene.rootNode.childNode(
                            withName: "sunlightNode",
                            recursively: true)?.light

                        if self.sunlightSwitch == true {
                            sunlight!.intensity = 2000.0
                        } else {
                            sunlight!.intensity = 0.0
                        }
                    }) {
                        Image(systemName: sunlightSwitch ? "lightbulb.fill" : "lightbulb")
                            .imageScale(.large)
                            .accessibility(label: Text("Light Switch"))
                            .padding()
                    }

                    Button(action: {
                        withAnimation {
                            self.cameraSwitch.toggle()
                        }
                        if self.cameraSwitch == false {
                            povName = "shipCamera"
                        }
                        if self.cameraSwitch == true {
                            povName = "distantCamera"
                        }
                        print("\(povName)")
                    }) {
                        Image(systemName: cameraSwitch ? "video.fill" : "video")
                            .imageScale(.large)
                            .accessibility(label: Text("Camera Switch"))
                            .padding()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
