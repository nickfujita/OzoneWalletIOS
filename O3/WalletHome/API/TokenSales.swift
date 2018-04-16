//
//  TokenSales.swift
//  O3
//
//  Created by Andrei Terentiev on 4/12/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

public struct TokenSales: Codable {
    var live: [SaleInfo]

    enum CodingKeys: String, CodingKey {
        case live
    }

    public init(live: [SaleInfo]) {
        self.live = live
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let live: [SaleInfo] = try container.decode([SaleInfo].self, forKey: .live)
        self.init(live: live)
    }

    public struct SaleInfo: Codable {
        var name: String
        var scriptHash: String
        var webURL: String
        var imageURL: String
        var startTime: Int
        var endTime: Int
        var acceptingAssets: [AcceptingAsset]
        var info: [InfoRow]

        enum CodingKeys: String, CodingKey {
            case name
            case scriptHash
            case webURL
            case imageURL
            case startTime
            case endTime
            case acceptingAssets
            case info
        }

        public init(name: String, scriptHash: String, webURL: String, imageURL: String, startTime: Int, endTime: Int,
                    acceptingAssets: [AcceptingAsset], info: [InfoRow]) {
            self.name = name
            self.scriptHash = scriptHash
            self.webURL = webURL
            self.imageURL = imageURL
            self.startTime = startTime
            self.endTime = endTime
            self.acceptingAssets = acceptingAssets
            self.info = info
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let name: String = try container.decode(String.self, forKey: .name)
            let scriptHash: String = try container.decode(String.self, forKey: .scriptHash)
            let webURL: String = try container.decode(String.self, forKey: .webURL)
            let imageURL: String = try container.decode(String.self, forKey: .imageURL)
            let startTime: Int = try container.decode(Int.self, forKey: .startTime)
            let endTime: Int = try container.decode(Int.self, forKey: .endTime)
            let acceptingAssets: [AcceptingAsset] = try container.decode([AcceptingAsset].self, forKey: .acceptingAssets)
            let info: [InfoRow] = try container.decode([InfoRow].self, forKey: .info)
            self.init(name: name, scriptHash: scriptHash, webURL: webURL, imageURL: imageURL, startTime: startTime, endTime: endTime, acceptingAssets: acceptingAssets, info: info)
        }

        public struct AcceptingAsset: Codable {
            var asset: String
            var basicRate: Double
            var min: Double
            var max: Double

            enum CodingKeys: String, CodingKey {
                case asset
                case basicRate
                case min
                case max
            }

            public init(asset: String, basicRate: Double, min: Double, max: Double) {
                self.asset = asset
                self.basicRate = basicRate
                self.min = min
                self.max = max
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let asset: String = try container.decode(String.self, forKey: .asset)
                let basicRate: Double = try container.decode(Double.self, forKey: .basicRate)
                let min: Double = try container.decode(Double.self, forKey: .min)
                let max: Double = try container.decode(Double.self, forKey: .max)
                self.init(asset: asset, basicRate: basicRate, min: min, max: max)
            }
        }

        public struct InfoRow: Codable {
            var label: String
            var value: String
            var link: String?

            enum CodingKeys: String, CodingKey {
                case label
                case value
                case link
            }

            public init(label: String, value: String, link: String?) {
                self.label = label
                self.value = value
                self.link = link
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let label: String = try container.decode(String.self, forKey: .label)
                let value: String = try container.decode(String.self, forKey: .value)
                let link: String? = try container.decodeIfPresent(String.self, forKey: .link)
                self.init(label: label, value: value, link: link)
            }
        }
    }
}
