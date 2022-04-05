import SwiftUI
import SceneKit
import SceneKit.ModelIO
import GLTFSceneKit


struct ContentView: View {

    private let BUNNY_BODY = "bunny_body"
    private let BUNNNY_GUTS = "guts"
    private let CAMERA_NAME = "camera"

    private let materialPrefixes : [String] = [
        "paper",
        "bamboo-wood-semigloss",
        "oakfloor2",
        "scuffed-plastic",
        "rustediron-streaks"];

    @State private var lightSwitch = true

    private var scene: SCNScene!
    private var matIndex = 0

    init() {
        self.scene = loadScene()!
        setupCamera()
        setupLighting()
        applyMaterial(matIndex)
    }

    private func loadScene() -> SCNScene? {
        do {
            let sceneSource = try! GLTFSceneSource(named: "scenes/bunny.glb")
            let scene = try sceneSource.scene(options: [:])

            // name some nodes for quick reference
            // wasn't able to get houdini to do this
            if let merge = scene.rootNode.childNode(withName: "merge", recursively: true),
               let guts = merge.childNodes.first,
               let bunny = merge.childNodes.last {
                bunny.name = BUNNY_BODY
                guts.name = BUNNNY_GUTS
            }

            return scene
        } catch {
            print("\(error.localizedDescription)")
            return nil
        }
    }

    private func setupCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(-2, 0.6, 2.6)
        cameraNode.look(at: SCNVector3Make(0, 0, 0))
        cameraNode.name = CAMERA_NAME
        scene.rootNode.addChildNode(cameraNode)

        cameraNode.camera?.wantsHDR = true
    }

    private func setupLighting() {
        // use IBL
        scene.lightingEnvironment.contents = "hdrs/Barce_Rooftop_C_3k.hdr"
        scene.lightingEnvironment.intensity = 2.0
        scene.background.contents = "hdrs/Barce_Rooftop_C_Env.hdr"
    }

    private func loadMaterialResource(_ named: String, type: String) -> UIImage? {
        guard let path = Bundle.main.path(forResource: "\(named)-\(type)",
                                          ofType: ".png",
                                          inDirectory: "materials/\(named)") else {
            return nil
        }
        return UIImage(contentsOfFile: path)
    }

    private func applyMaterial(_ idx: Int) {
        if let bunny = scene.rootNode.childNode(withName: BUNNY_BODY, recursively: true),
           let material = bunny.geometry?.firstMaterial {

            // Declare that you intend to work in PBR shading mode
            // Note that this requires iOS 10 and up
            material.lightingModel = SCNMaterial.LightingModel.physicallyBased

            // Setup the material maps for your object
            let materialFilePrefix = materialPrefixes[idx];
            material.diffuse.contents = loadMaterialResource(materialFilePrefix, type: "albedo")
            material.roughness.contents = loadMaterialResource(materialFilePrefix, type: "roughness")
            material.metalness.contents = loadMaterialResource(materialFilePrefix, type: "metal")
            material.normal.contents = loadMaterialResource(materialFilePrefix, type: "normal")
        }
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if let scene = scene {
                SceneView(
                    scene: scene,
                    pointOfView: scene.rootNode.childNode(withName: CAMERA_NAME, recursively: true),
                    options: [.allowsCameraControl]
                )
            }

            VStack {
                Spacer()

                HStack(spacing: 5) {
                    Button(action: {
    //                        withAnimation {
    //                            self.lightSwitch.toggle()
    //                        }

    //                        let sunlight = self.scene.rootNode.childNode(
    //                            withName: "sunlightNode",
    //                            recursively: true)?.light
    //
    //                        if self.sunlightSwitch == true {
    //                            sunlight!.intensity = 2000.0
    //                        } else {
    //                            sunlight!.intensity = 0.0
    //                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .imageScale(.large)
                            .foregroundColor(.white)
                            .accessibility(label: Text("Next Material"))
                            .padding()
                    }

                    Button(action: {
                        withAnimation {
                            self.lightSwitch.toggle()
                        }

//                        let sunlight = self.scene.rootNode.childNode(
//                            withName: "sunlightNode",
//                            recursively: true)?.light
//
//                        if self.sunlightSwitch == true {
//                            sunlight!.intensity = 2000.0
//                        } else {
//                            sunlight!.intensity = 0.0
//                        }
                    }) {
                        Image(systemName: "lasso.and.sparkles")
                            .imageScale(.large)
                            .foregroundColor(.white)
                            .accessibility(label: Text("Material"))
                            .padding()
                    }

                    Button(action: {
                        withAnimation {
                            self.lightSwitch.toggle()
                        }

//                        let sunlight = self.scene.rootNode.childNode(
//                            withName: "sunlightNode",
//                            recursively: true)?.light
//
//                        if self.sunlightSwitch == true {
//                            sunlight!.intensity = 2000.0
//                        } else {
//                            sunlight!.intensity = 0.0
//                        }
                    }) {
                        Image(systemName: lightSwitch ? "lightbulb.fill" : "lightbulb")
                            .imageScale(.large)
                            .foregroundColor(.white)
                            .accessibility(label: Text("Light Switch"))
                            .padding()
                    }

                    Button(action: {
//                        withAnimation {
//                            self.lightSwitch.toggle()
//                        }

//                        let sunlight = self.scene.rootNode.childNode(
//                            withName: "sunlightNode",
//                            recursively: true)?.light
//
//                        if self.sunlightSwitch == true {
//                            sunlight!.intensity = 2000.0
//                        } else {
//                            sunlight!.intensity = 0.0
//                        }
                    }) {
                        Image(systemName: "arrow.right")
                            .imageScale(.large)
                            .foregroundColor(.white)
                            .accessibility(label: Text("Next Material"))
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
