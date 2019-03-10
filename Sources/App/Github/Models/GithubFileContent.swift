import Vapor

public enum FileType: String, Content {
    case file
    case directory = "dir"
    case symlink
    case submodule
    
}

public extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

public struct GithubFileContent: Content {
    let name: String
    let path: String
    let rawContent: String
    let type: FileType
    let sha: String
    
    var content: [String] {
        let split = rawContent.split(separator: "\n")
        
        return split.map { line in
            let decodedData = Data(base64Encoded: String(line))!
            let decodedString = String(data: decodedData, encoding: .utf8)!
            return decodedString
        }.joined().split(separator: "\n").map { String($0) }
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case path
        case rawContent = "content"
        case type
        case sha
    }
}
//{
//    "name": "Parameters.swift",
//    "path": "Sources/RoutingKit/Parameters.swift",
//    "sha": "0a05a9addc6177532dd4938af86512109088d2e4",
//    "size": 1818,
//    "url": "https://api.github.com/repos/twof/routing/contents/Sources/RoutingKit/Parameters.swift?ref=master",
//    "html_url": "https://github.com/twof/routing/blob/master/Sources/RoutingKit/Parameters.swift",
//    "git_url": "https://api.github.com/repos/twof/routing/git/blobs/0a05a9addc6177532dd4938af86512109088d2e4",
//    "download_url": "https://raw.githubusercontent.com/twof/routing/master/Sources/RoutingKit/Parameters.swift",
//    "type": "file",
//    "content": "aW1wb3J0IEZvdW5kYXRpb24KCi8vLyBIb2xkcyBkeW5hbWljIHBhdGggY29t\ncG9uZW50cyB0aGF0IHdlcmUgZGlzY292ZXJlZCB3aGlsZSByb3V0aW5nLgov\nLy8KLy8vIEFmdGVyIHRoaXMgc3RydWN0IGhhcyBiZWVuIGZpbGxlZCB3aXRo\nIHBhcmFtZXRlciB2YWx1ZXMsIHlvdSBjYW4gZmV0Y2gKLy8vIHRoZW0gb3V0\nIGJ5IG5hbWUgdXNpbmcgYGdldChfOilgLgovLy8KLy8vICAgICBsZXQgcG9z\ndElEID0gcGFyYW1ldGVycy5nZXQoInBvc3RfaWQiKQovLy8KcHVibGljIHN0\ncnVjdCBQYXJhbWV0ZXJzIHsKICAgIC8vLyBJbnRlcm5hbCBzdG9yYWdlLgog\nICAgcHJpdmF0ZSB2YXIgdmFsdWVzOiBbU3RyaW5nOiBTdHJpbmddCgogICAg\nLy8vIENyZWF0ZXMgYSBuZXcgYFBhcmFtZXRlcnNgLgogICAgLy8vCiAgICAv\nLy8gUGFzcyB0aGlzIGludG8gdGhlIGBSb3V0ZXIucm91dGUocGF0aDpwYXJh\nbWV0ZXJzOilgIG1ldGhvZCB0byBmaWxsIHdpdGggdmFsdWVzLgogICAgcHVi\nbGljIGluaXQoKSB7CiAgICAgICAgdmFsdWVzID0gWzpdCiAgICB9CgogICAg\nLy8vIEdyYWJzIHRoZSBuYW1lZCBwYXJhbWV0ZXIgZnJvbSB0aGUgcGFyYW1l\ndGVyIGJhZy4KICAgIC8vLwogICAgLy8vIEZvciBleGFtcGxlIEdFVCAvcG9z\ndHMvOnBvc3RfaWQvY29tbWVudHMvOmNvbW1lbnRfaWQKICAgIC8vLyB3b3Vs\nZCBiZSBmZXRjaGVkIHVzaW5nOgogICAgLy8vCiAgICAvLy8gICAgIGxldCBw\nb3N0SUQgPSBwYXJhbWV0ZXJzLmdldCgicG9zdF9pZCIpCiAgICAvLy8gICAg\nIGxldCBjb21tZW50SUQgPSBwYXJhbWV0ZXJzLmdldCgiY29tbWVudF9pZCIp\nCiAgICAvLy8KICAgIHB1YmxpYyBmdW5jIGdldChfIG5hbWU6IFN0cmluZykg\nLT4gU3RyaW5nPyB7CiAgICAgICAgcmV0dXJuIHNlbGYudmFsdWVzW25hbWVd\nCiAgICB9CiAgICAKICAgIC8vLyBHcmFicyB0aGUgbmFtZWQgcGFyYW1ldGVy\nIGZyb20gdGhlIHBhcmFtZXRlciBiYWcsIGNhc3RpbmcgaXQgdG8KICAgIC8v\nLyBhIGBMb3NzbGVzc1N0cmluZ0NvbnZlcnRpYmxlYCB0eXBlLgogICAgLy8v\nCiAgICAvLy8gRm9yIGV4YW1wbGUgR0VUIC9wb3N0cy86cG9zdF9pZC9jb21t\nZW50cy86Y29tbWVudF9pZAogICAgLy8vIHdvdWxkIGJlIGZldGNoZWQgdXNp\nbmc6CiAgICAvLy8KICAgIC8vLyAgICAgbGV0IHBvc3RJRCA9IHBhcmFtZXRl\ncnMuZ2V0KCJwb3N0X2lkIiwgYXM6IEludC5zZWxmKQogICAgLy8vICAgICBs\nZXQgY29tbWVudElEID0gcGFyYW1ldGVycy5nZXQoImNvbW1lbnRfaWQiLCBh\nczogSW50LnNlbGYpCiAgICAvLy8KICAgIHB1YmxpYyBmdW5jIGdldDxUPihf\nIG5hbWU6IFN0cmluZywgYXMgdHlwZTogVC5UeXBlKSAtPiBUPwogICAgICAg\nIHdoZXJlIFQ6IExvc3NsZXNzU3RyaW5nQ29udmVydGlibGUKICAgIHsKICAg\nICAgICByZXR1cm4gc2VsZi5nZXQobmFtZSkuZmxhdE1hcChULmluaXQpCiAg\nICB9CiAgICAKICAgIC8vLyBBZGRzIGEgbmV3IHBhcmFtZXRlciB2YWx1ZSB0\nbyB0aGUgYmFnLgogICAgLy8vCiAgICAvLy8gLSBub3RlOiBUaGUgdmFsdWUg\nd2lsbCBiZSBwZXJjZW50LWRlY29kZWQuCiAgICAvLy8KICAgIC8vLyAtIHBh\ncmFtZXRlcnM6CiAgICAvLy8gICAgIC0gbmFtZTogVW5pcXVlIHBhcmFtZXRl\nciBuYW1lCiAgICAvLy8gICAgIC0gdmFsdWU6IFZhbHVlIChwZXJjZW50LWVu\nY29kZWQgaWYgbmVjZXNzYXJ5KQogICAgcHVibGljIG11dGF0aW5nIGZ1bmMg\nc2V0KF8gbmFtZTogU3RyaW5nLCB0byB2YWx1ZTogU3RyaW5nPykgewogICAg\nICAgIHNlbGYudmFsdWVzW25hbWVdID0gdmFsdWU/LnJlbW92aW5nUGVyY2Vu\ndEVuY29kaW5nCiAgICB9Cn0K\n",
//    "encoding": "base64",
//    "_links": {
//        "self": "https://api.github.com/repos/twof/routing/contents/Sources/RoutingKit/Parameters.swift?ref=master",
//        "git": "https://api.github.com/repos/twof/routing/git/blobs/0a05a9addc6177532dd4938af86512109088d2e4",
//        "html": "https://github.com/twof/routing/blob/master/Sources/RoutingKit/Parameters.swift"
//    }
//}
