import ARKit
import SwiftUI
import RealityKit
import Observation

@Observable
@MainActor
class ImageTrackingModel {

    let markers = ["marker_1", "marker_2", "marker_3", "marker_4", "marker_5"]
    
    private let session = ARKitSession()

    private let imageTrackingProvider = ImageTrackingProvider(
        referenceImages: ReferenceImage.loadReferenceImages(inGroupNamed: "Target")
    )

    private var contentEntity = Entity()
    private var entityMap: [UUID: ModelEntity] = [:]

    // MARK: - Public

    func setupContentEntity() -> Entity {
        return contentEntity
    }

    func runSession() async {
        do {
            if ImageTrackingProvider.isSupported {
                try await session.run([imageTrackingProvider])
                print("[\(type(of: self))] [\(#function)] session.run")
            }
        } catch {
            print(error)
        }
    }

    func processImageTrackingUpdates() async {
        print("[\(type(of: self))] [\(#function)] called")

        for await update in imageTrackingProvider.anchorUpdates {
            print("[\(type(of: self))] [\(#function)] anchorUpdates")

            updateImage(update.anchor)

        }
    }

    func monitorSessionEvents() async {
        for await event in session.events {
            switch event {
            case .authorizationChanged(type: _, status: let status):
                print("Authorization changed to: \(status)")
                if status == .denied {
                    print("Authorization status: denied")
                }
            case .dataProviderStateChanged(dataProviders: let providers, newState: let state, error: let error):
                print("Data provider changed: \(providers), \(state)")
                if let error {
                    print("Data provider reached an error state: \(error)")
                }
            @unknown default:
                fatalError("Unhandled new event type \(event)")
            }
        }
    }

    // MARK: - Private

    private func updateImage(_ anchor: ImageAnchor) {

        guard let anchorName = anchor.referenceImage.name else
        {
            return
        }
        let markerID = self.markers.firstIndex(of: anchorName)!
        let opacity = SharedData.shared.opacity[markerID]
        let opacityVal = PhysicallyBasedMaterial.Opacity(floatLiteral: Float(opacity))

        if entityMap[anchor.id] == nil
        {
            let entity = ModelEntity(mesh: .generatePlane(width: 0.5, depth: 0.7))
//            let material = UnlitMaterial(color: UIColor.blue.withAlphaComponent(0.65))
            var material = UnlitMaterial()
            material.color = .init(tint: .gray.withAlphaComponent(opacity))
            material.blending = .transparent(opacity: opacityVal)
            entity.model?.materials = [material]
            entityMap[anchor.id] = entity
            contentEntity.addChild(entity)
        }
        else{
            if let model = entityMap[anchor.id]!.model
            {
                var material = UnlitMaterial()
                material.color = .init(tint: .gray.withAlphaComponent(opacity))
                material.blending = .transparent(opacity: opacityVal)
                entityMap[anchor.id]?.model?.materials = [material]
//                model.materials = [material]
            }
        }
        print(anchor.isTracked)

        if anchor.isTracked {
            entityMap[anchor.id]?.transform = Transform(matrix: anchor.originFromAnchorTransform)
            entityMap[anchor.id]?.transform.translation += SIMD3<Float>(-0.2, 0.4, 0)
        }
    }
}
