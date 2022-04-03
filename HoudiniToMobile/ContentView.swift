import SwiftUI
import SceneKit
import SceneKit.ModelIO
import GLTFSceneKit


struct ContentView: View {

//    @State private var sunlightSwitch = true
//    @State private var cameraSwitch = true
    @State private var povName = "distantCamera"
//    @State private var magnification = CGFloat(1.0)
//    @State private var isDragging = false
//    @State private var totalChangePivot = SCNMatrix4Identity

    private var scene: SCNScene!

    init() {
        self.scene = loadScene()!
//        self.scene = testScene()
        setupCamera()
        setupLighting()
    }

    private func loadScene() -> SCNScene? {
        do {
            let sceneSource = try! GLTFSceneSource(named: "scenes/bunny.glb")
            let scene = try sceneSource.scene(options: [:])

            print("Whats in our scene?")
            print("rootNode", scene.rootNode)
            print("children", scene.rootNode.childNodes)
            print("bunny", scene.rootNode.childNodes.first!)
            print("background", scene.lightingEnvironment)
            print("lightingEnvironment", scene.lightingEnvironment)

            return scene
        } catch {
            print("\(error.localizedDescription)")
            return nil
        }
    }

    private func testScene() -> SCNScene {
        let scene = SCNScene()

        let boxGeo = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
        let boxNode = SCNNode(geometry: boxGeo)
        scene.rootNode.addChildNode(boxNode)

        return scene
    }

    private func setupCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 25)
        cameraNode.name = _povName.wrappedValue
        scene.rootNode.addChildNode(cameraNode)

        //        let thing = scene.rootNode.childNode(withName: povName, recursively: true)!

        //        thing.camera?.wantsDepthOfField = true
        //        thing.camera?.focusDistance = 0.8
        //        thing.camera?.fStop = 5.6
        //        thing.camera?.wantsHDR = true

        //        thing.camera?.motionBlurIntensity = 1.0

        //        thing.camera?.screenSpaceAmbientOcclusionIntensity = 1.0
    }

    private func setupLighting() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)

        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = .omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if let scene = scene {
                SceneView(
                    scene: scene,
                    pointOfView: scene.rootNode.childNode(withName: povName, recursively: true),
                    options: [.allowsCameraControl]
                )
            }

            VStack {
//                Text("Hello, SwiftUI!")
//                    .multilineTextAlignment(.leading)
//                    .padding()
//                    .foregroundColor(.gray)
//                    .font(.largeTitle)
//
//                Text("And SceneView too")
//                    .foregroundColor(.gray)
//                    .font(.title2)

//                Spacer(minLength: 300)

                /*
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
                 */
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
