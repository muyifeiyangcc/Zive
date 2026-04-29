import Foundation
import Combine

enum ZiveLocalFileStore {
    static func ziveLocalFileStoreLoad<Model: Decodable>(
        from fileName: String,
        as type: Model.Type
    ) -> Model? {
        let ziveLocalFileStoreUrl = ziveLocalFileStoreDocumentsDirectory()
            .appendingPathComponent(fileName)

        guard let ziveLocalFileStoreData = try? Data(contentsOf: ziveLocalFileStoreUrl) else {
            return nil
        }

        return try? JSONDecoder().decode(type, from: ziveLocalFileStoreData)
    }

    static func ziveLocalFileStoreSave<Model: Encodable>(
        _ model: Model,
        to fileName: String
    ) {
        let ziveLocalFileStoreUrl = ziveLocalFileStoreDocumentsDirectory()
            .appendingPathComponent(fileName)

        guard let ziveLocalFileStoreData = try? JSONEncoder().encode(model) else {
            return
        }

        try? ziveLocalFileStoreData.write(to: ziveLocalFileStoreUrl, options: .atomic)
    }

    private static func ziveLocalFileStoreDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
