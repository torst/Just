//
//  RequestsTests.swift
//  RequestsTests
//
//  Created by Daniel Duan on 4/18/15.
//
//

import Requests
import Quick
import Nimble

class RequestsSpec: QuickSpec {
    override func spec() {

        describe("basic authentication") {
            it("should fail at a challenge when auth is missing") {
                let r = Requests.get("http://httpbin.org/basic-auth/dan/pass")
                expect(r.ok).to(beFalse())
            }
            it("should succeed at a challenge when auth info is correct") {
                let username = "dan"
                let password = "password"
                let r = Requests.get("http://httpbin.org/basic-auth/\(username)/\(password)", auth:(username, password))
                expect(r.ok).to(beTrue())
            }
            it("should fail a challenge when auth contains wrong value") {
                let username = "dan"
                let password = "password"
                let r = Requests.get("http://httpbin.org/basic-auth/\(username)/\(password)x", auth:(username, password))
                expect(r.ok).to(beFalse())
                expect(r.statusCode).to(equal(401))
            }
        }

        describe("cookies") {
            it("should get cookies contained in responses") {
                let r = Requests.get("http://httpbin.org/cookies/set/test/requests", allowRedirects:false)
                expect(r.cookies).toNot(beEmpty())
                expect(r.cookies.keys.array).to(contain("test"))
                if let cookie = r.cookies["test"] {
                    expect(cookie.value).to(equal("requests"))
                }
            }
            it("sends cookies in specified in requests") {
                Requests.get("http://httpbin.org/cookies/delete?test")
                let r = Requests.get("http://httpbin.org/cookies", cookies:["test":"requests"])

                if let cookieValue = (r.json as! [String:[String:String]])["cookies"]?["test"] {
                    expect(cookieValue).to(equal("requests"))
                } else {
                    fail("httpbin did not find specified cookies")
                }
            }
        }
    }
}
