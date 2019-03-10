import Vapor

public struct GithubService: Service {
    let accessToken: String
    
    public init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    public func postComment(repo: String, issue: Int, body: String, on req: Request) -> Future<CreateCommentResponse> {
        let requestURL = "https://api.github.com/repos/\(repo)/issues/\(issue)/comments?access_token=\(self.accessToken)"
        let headers = HTTPHeaders(dictionaryLiteral:
            (HTTPHeaderName.contentType.description, "application/json")
        )
        
        do {
            let client = try req.client()
            
            return client.post(requestURL, headers: headers, beforeSend: { req in
                try req.content.encode(CreateGithubCommentBody(body: body))
            }).flatMap { response in
                return try response.content.decode(CreateCommentResponse.self)
            }
        } catch {
            return req.future(error: error)
        }
    }
    
    public func getFileContents(repo: String, filePath: String, on req: Request) -> Future<GithubFileContent> {
        let requestURL = "https://api.github.com/repos/\(repo)/contents/\(filePath)?access_token=\(self.accessToken)"
        
        do {
            let client = try req.client()
            
            return client.get(requestURL).flatMap { fileContentResponse in
                return try fileContentResponse.content.decode(GithubFileContent.self)
            }
        } catch {
            return req.future(error: error)
        }
    }
    
    struct GithubUpdateFileUser: Content {
        let name: String
        let email: String
    }
    
    struct GithubUpdateFileRequestBody: Content {
        let message: String
        let content: String
        let sha: String
//        let branch: String
//        let committer: GithubUpdateFileUser
//        let author: GithubUpdateFileUser
    }
    
    struct GithubUpdateFileResponse: Content {
        
    }
    
    
    public func setFileContents(
        repo: String,
        filePath: String,
        newContents: String,
        fileSHA: String,
        on req: Request
    ) -> Future<Response> {
        let requestURL = "https://api.github.com/repos/\(repo)/contents/\(filePath)?access_token=\(self.accessToken)"
        
        let headers = HTTPHeaders(dictionaryLiteral:
            (HTTPHeaderName.contentType.description, "application/json")
        )
        
        do {
            let client = try req.client()
            
            return client.put(requestURL, headers: headers, beforeSend: { (req) in
                let reqBody = GithubUpdateFileRequestBody(
                    message: "Chaos coming through",
                    content: newContents.toBase64(),
                    sha: fileSHA
                )
                try req.content.encode(reqBody)
            }).map { response in
                return response
            }
        } catch {
            return req.future(error: error)
        }
    }
    
//    public func getPermissionLevel(for username: String, for repo: String) throws -> Future<>
}

//{
//    "content": {
//        "name": "hello.txt",
//        "path": "notes/hello.txt",
//        "sha": "95b966ae1c166bd92f8ae7d1c313e738c731dfc3",
//        "size": 9,
//        "url": "https://api.github.com/repos/octocat/Hello-World/contents/notes/hello.txt",
//        "html_url": "https://github.com/octocat/Hello-World/blob/master/notes/hello.txt",
//        "git_url": "https://api.github.com/repos/octocat/Hello-World/git/blobs/95b966ae1c166bd92f8ae7d1c313e738c731dfc3",
//        "download_url": "https://raw.githubusercontent.com/octocat/HelloWorld/master/notes/hello.txt",
//        "type": "file",
//        "_links": {
//            "self": "https://api.github.com/repos/octocat/Hello-World/contents/notes/hello.txt",
//            "git": "https://api.github.com/repos/octocat/Hello-World/git/blobs/95b966ae1c166bd92f8ae7d1c313e738c731dfc3",
//            "html": "https://github.com/octocat/Hello-World/blob/master/notes/hello.txt"
//        }
//    },
//    "commit": {
//        "sha": "7638417db6d59f3c431d3e1f261cc637155684cd",
//        "node_id": "MDY6Q29tbWl0NzYzODQxN2RiNmQ1OWYzYzQzMWQzZTFmMjYxY2M2MzcxNTU2ODRjZA==",
//        "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/7638417db6d59f3c431d3e1f261cc637155684cd",
//        "html_url": "https://github.com/octocat/Hello-World/git/commit/7638417db6d59f3c431d3e1f261cc637155684cd",
//        "author": {
//            "date": "2014-11-07T22:01:45Z",
//            "name": "Scott Chacon",
//            "email": "schacon@gmail.com"
//        },
//        "committer": {
//            "date": "2014-11-07T22:01:45Z",
//            "name": "Scott Chacon",
//            "email": "schacon@gmail.com"
//        },
//        "message": "my commit message",
//        "tree": {
//            "url": "https://api.github.com/repos/octocat/Hello-World/git/trees/691272480426f78a0138979dd3ce63b77f706feb",
//            "sha": "691272480426f78a0138979dd3ce63b77f706feb"
//        },
//        "parents": [
//        {
//        "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/1acc419d4d6a9ce985db7be48c6349a0475975b5",
//        "html_url": "https://github.com/octocat/Hello-World/git/commit/1acc419d4d6a9ce985db7be48c6349a0475975b5",
//        "sha": "1acc419d4d6a9ce985db7be48c6349a0475975b5"
//        }
//        ],
//        "verification": {
//            "verified": false,
//            "reason": "unsigned",
//            "signature": null,
//            "payload": null
//        }
//    }
//}
