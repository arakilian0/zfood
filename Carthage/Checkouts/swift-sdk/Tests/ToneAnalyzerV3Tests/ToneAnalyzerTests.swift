/**
 * (C) Copyright IBM Corp. 2016, 2019.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

// swiftlint:disable function_body_length force_try force_unwrapping file_length

import XCTest
import Foundation
import ToneAnalyzerV3

class ToneAnalyzerTests: XCTestCase {

    private var toneAnalyzer: ToneAnalyzer!

    static var allTests: [(String, (ToneAnalyzerTests) -> () throws -> Void)] {
        return [
            ("testGetToneJSON", testGetToneJSON),
            ("testGetTonePlainText", testGetTonePlainText),
            ("testGetToneHTML", testGetToneHTML),
            ("testGetToneCustom", testGetToneCustom),
            ("testToneChat", testToneChat),
            ("testGetToneEmptyString", testGetToneEmptyString),
            ("testToneChatEmptyArray", testToneChatEmptyArray),
        ]
    }

    let text = """
        I know the times are difficult! Our sales have been disappointing for the past three quarters for
        our data analytics product suite. We have a competitive data analytics product suite in the industry.
        But we need to do our job selling it!
    """

    let utterances = [
        Utterance(text: "My charger isn't working.", user: "customer"),
        Utterance(text: "Thanks for reaching out. Can you give me some more detail about the issue?", user: "agent"),
        Utterance(text: "I put my charger in my phone last night to charge and it isn't working. " +
            "Which is ridiculous, it's a new charger, I bought it yesterday.", user: "customer"),
        Utterance(text: "I'm sorry you're having issues with charging. What kind of charger do you have?", user: "agent"),
    ]

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateToneAnalyzer()
    }

    /** Instantiate Tone Analyzer. */
    func instantiateToneAnalyzer() {
        if let apiKey = WatsonCredentials.ToneAnalyzerAPIKey {
            toneAnalyzer = ToneAnalyzer(version: versionDate, apiKey: apiKey)
        } else {
            let username = WatsonCredentials.ToneAnalyzerUsername
            let password = WatsonCredentials.ToneAnalyzerPassword
            toneAnalyzer = ToneAnalyzer(version: versionDate, username: username, password: password)
        }
        if let url = WatsonCredentials.ToneAnalyzerURL {
            toneAnalyzer.serviceURL = url
        }
        toneAnalyzer.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        toneAnalyzer.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 5.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    func testGetToneJSON() {
        let expectation = self.expectation(description: "Get tone.")
        toneAnalyzer.tone(toneContent: .toneInput(ToneInput(text: text))) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let toneAnalysis = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(toneAnalysis.documentTone.tones)
            XCTAssertGreaterThan(toneAnalysis.documentTone.tones!.count, 0)
            XCTAssertNotNil(toneAnalysis.sentencesTone)
            XCTAssertGreaterThan(toneAnalysis.sentencesTone!.count, 0)
            for sentenceAnalysis in toneAnalysis.sentencesTone! {
                XCTAssertNotNil(sentenceAnalysis.tones)
                XCTAssertGreaterThan(sentenceAnalysis.tones!.count, 0)
                XCTAssertNil(sentenceAnalysis.toneCategories)
                XCTAssertNil(sentenceAnalysis.inputFrom)
                XCTAssertNil(sentenceAnalysis.inputTo)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetTonePlainText() {
        let expectation = self.expectation(description: "Get tone.")
        toneAnalyzer.tone(toneContent: .text(text)) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let toneAnalysis = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(toneAnalysis.documentTone.tones)
            XCTAssertGreaterThan(toneAnalysis.documentTone.tones!.count, 0)
            XCTAssertNotNil(toneAnalysis.sentencesTone)
            XCTAssertGreaterThan(toneAnalysis.sentencesTone!.count, 0)
            for sentenceAnalysis in toneAnalysis.sentencesTone! {
                XCTAssertNotNil(sentenceAnalysis.tones)
                XCTAssertGreaterThan(sentenceAnalysis.tones!.count, 0)
                XCTAssertNil(sentenceAnalysis.toneCategories)
                XCTAssertNil(sentenceAnalysis.inputFrom)
                XCTAssertNil(sentenceAnalysis.inputTo)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetToneHTML() {
        let expectation = self.expectation(description: "Get tone.")
        let html = "<!DOCTYPE html><html><body><p>\(text)</p></body></html>"
        toneAnalyzer.tone(toneContent: .html(html)) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let toneAnalysis = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(toneAnalysis.documentTone.tones)
            XCTAssertGreaterThan(toneAnalysis.documentTone.tones!.count, 0)
            XCTAssertNotNil(toneAnalysis.sentencesTone)
            XCTAssertGreaterThan(toneAnalysis.sentencesTone!.count, 0)
            for sentenceAnalysis in toneAnalysis.sentencesTone! {
                XCTAssertNotNil(sentenceAnalysis.tones)
                XCTAssertNil(sentenceAnalysis.toneCategories)
                XCTAssertNil(sentenceAnalysis.inputFrom)
                XCTAssertNil(sentenceAnalysis.inputTo)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetToneCustom() {
        let expectation = self.expectation(description: "Get tone with custom parameters.")
        toneAnalyzer.tone(
            toneContent: .toneInput(ToneInput(text: text)),
            sentences: false,
            contentLanguage: "en",
            acceptLanguage: "en")
        {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let toneAnalysis = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(toneAnalysis.documentTone.tones)
            XCTAssertGreaterThan(toneAnalysis.documentTone.tones!.count, 0)
            XCTAssertNil(toneAnalysis.sentencesTone)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testToneChat() {
        let expectation = self.expectation(description: "Tone chat.")
        toneAnalyzer.toneChat(utterances: utterances, acceptLanguage: "en") {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let analyses = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssert(!analyses.utterancesTone.isEmpty)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    func testGetToneEmptyString() {
        let expectation = self.expectation(description: "Get tone with an empty string.")
        toneAnalyzer.tone(toneContent: .toneInput(ToneInput(text: ""))) {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testToneChatEmptyArray() {
        let expectation = self.expectation(description: "Tone chat with an empty array.")
        toneAnalyzer.toneChat(utterances: [], acceptLanguage: "en") {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
