//
//  CLLocationCoordinate2D+Codable.swift.swift
//  DialogflowModels
//
//  Created by Max Lesichniy on 08.09.2020.
//

#if !os(Linux) && canImport(CoreLocation)
import Foundation
import CoreLocation.CLLocation

extension CLLocationCoordinate2D: Codable {
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(latitude: try container.decode(CLLocationDegrees.self, forKey: .latitude),
                  longitude: try container.decode(CLLocationDegrees.self, forKey: .longitude))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .latitude)
    }
    
}
#endif
