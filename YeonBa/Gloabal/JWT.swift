//
//  JWT.swift
//  YeonBa
//
//  Created by 김민솔 on 5/25/24.
//

import Foundation

extension String {
    func base64UrlDecoded() -> Data? {
        var base64 = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let paddingLength = base64.count % 4
        if paddingLength > 0 {
            base64.append(String(repeating: "=", count: 4 - paddingLength))
        }

        return Data(base64Encoded: base64)
    }
}

struct JWT {
    let header: [String: Any]
    let payload: [String: Any]

    init?(token: String) {
        let segments = token.split(separator: ".")
        guard segments.count == 3 else { return nil }

        guard let headerData = String(segments[0]).base64UrlDecoded(),
              let payloadData = String(segments[1]).base64UrlDecoded(),
              let header = try? JSONSerialization.jsonObject(with: headerData, options: []) as? [String: Any],
              let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else {
            return nil
        }

        self.header = header
        self.payload = payload
    }

    var userId: Int? {
        return payload["userId"] as? Int
    }
}
