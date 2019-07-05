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

#if os(Linux)
#else

import XCTest
import Foundation
import RestKit
import SpeechToTextV1

class SpeechToTextRecognizeTests: XCTestCase {

    private var speechToText: SpeechToText!
    private let timeout: TimeInterval = 20.0

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        instantiateSpeechToText()
    }

    func instantiateSpeechToText() {
        if let apiKey = WatsonCredentials.SpeechToTextAPIKey {
            speechToText = SpeechToText(apiKey: apiKey)
        } else {
            let username = WatsonCredentials.SpeechToTextUsername
            let password = WatsonCredentials.SpeechToTextPassword
            speechToText = SpeechToText(username: username, password: password)
        }
        if let url = WatsonCredentials.SpeechToTextURL {
            speechToText.serviceURL = url
        }
        speechToText.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        speechToText.defaultHeaders["X-Watson-Test"] = "true"
    }

    func cannotLocateFileMessage(_ fileName: String, _ withExtension: String) -> String {
        return "Unable to locate \(fileName).\(withExtension)"
    }

    func cannotReadFileMessage(_ fileName: String, _ withExtension: String) -> String {
        return "Unable to read \(fileName).\(withExtension)"
    }

    // MARK: - Test Definition for Linux

    static var allTests: [(String, (SpeechToTextRecognizeTests) -> () throws -> Void)] {
        return [
            ("testTranscribeFileDefaultWAV", testTranscribeFileDefaultWAV),
            ("testTranscribeFileDefaultOpus", testTranscribeFileDefaultOpus),
            ("testTranscribeFileDefaultFLAC", testTranscribeFileDefaultFLAC),
            ("testTranscribeFileCustomWAV", testTranscribeFileCustomWAV),
            ("testTranscribeFileCustomOpus", testTranscribeFileCustomOpus),
            ("testTranscribeFileCustomFLAC", testTranscribeFileCustomFLAC),
            ("testTranscribeDataDefaultWAV", testTranscribeDataDefaultWAV),
            ("testTranscribeDataDefaultOpus", testTranscribeDataDefaultOpus),
            ("testTranscribeDataDefaultFLAC", testTranscribeDataDefaultFLAC),
            ("testTranscribeDataCustomWAV", testTranscribeDataCustomWAV),
            ("testTranscribeDataCustomOpus", testTranscribeDataCustomOpus),
            ("testTranscribeDataCustomFLAC", testTranscribeDataCustomFLAC),
            ("testTranscribeStockAnnouncementCustomWAV", testTranscribeStockAnnouncementCustomWAV),
            ("testTranscribeDataWithSpeakerLabelsWAV", testTranscribeDataWithSpeakerLabelsWAV),
            ("testTranscribeDataWithSpeakerLabelsOpus", testTranscribeDataWithSpeakerLabelsOpus),
            ("testTranscribeDataWithSpeakerLabelsFLAC", testTranscribeDataWithSpeakerLabelsFLAC),
            ("testResultsAccumulator", testResultsAccumulator),
            ("testTranscribeStreaming", testTranscribeStreaming),
        ]
    }

    // MARK: - Transcribe File, Default Settings

    func testTranscribeFileDefaultWAV() {
        transcribeFileDefault(filename: "SpeechSample", withExtension: "wav", format: "audio/wav")
    }

    func testTranscribeFileDefaultOpus() {
        transcribeFileDefault(filename: "SpeechSample", withExtension: "ogg", format: "audio/ogg;codecs=opus")
    }

    func testTranscribeFileDefaultFLAC() {
        transcribeFileDefault(filename: "SpeechSample", withExtension: "flac", format: "audio/flac")
    }

    func testTranscribeFileNoFormat() {
        transcribeFileDefault(filename: "SpeechSample", withExtension: "wav", format: nil)
    }

    func transcribeFileDefault(filename: String, withExtension: String, format: String?) {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail(cannotLocateFileMessage(filename, withExtension))
            return
        }
        let fileData = try! Data(contentsOf: file)

        let settings = RecognitionSettings(contentType: format)

        var callback = RecognizeCallback()
        callback.onError = { error in
            XCTFail(unexpectedErrorMessage(error))
        }
        callback.onResults = { results in
            self.validateSTTResults(results: results, settings: settings)
            XCTAssertNotNil(results.results)
            XCTAssertEqual(results.results!.count, 1)
            XCTAssert(results.results!.last?.finalResults == true)
            let transcript = results.results!.last?.alternatives.last?.transcript
            XCTAssertNotNil(transcript)
            XCTAssertGreaterThan(transcript!.count, 0)
            expectation.fulfill()
        }
        speechToText.recognizeUsingWebSocket(audio: fileData, settings: settings, callback: callback)
        wait(for: [expectation], timeout: timeout)
    }

     // MARK: - Transcribe File, Custom Settings

    func testTranscribeFileCustomWAV() {
        transcribeFileCustom(filename: "SpeechSample", withExtension: "wav", format: "audio/wav")
    }

    func testTranscribeFileCustomOpus() {
        transcribeFileCustom(filename: "SpeechSample", withExtension: "ogg", format: "audio/ogg;codecs=opus")
    }

    func testTranscribeFileCustomFLAC() {
        transcribeFileCustom(filename: "SpeechSample", withExtension: "flac", format: "audio/flac")
    }

    func testTranscribeFileCustomNoFormat() {
        transcribeFileCustom(filename: "SpeechSample", withExtension: "ogg", format: nil)
    }

    func transcribeFileCustom(filename: String, withExtension: String, format: String?) {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail(cannotLocateFileMessage(filename, withExtension))
            return
        }
        let fileData = try! Data(contentsOf: file)

        var settings = RecognitionSettings(contentType: format)
        settings.inactivityTimeout = -1
        settings.keywords = ["tornadoes"]
        settings.keywordsThreshold = 0.75
        settings.maxAlternatives = 3
        settings.interimResults = true
        settings.wordAlternativesThreshold = 0.25
        settings.wordConfidence = true
        settings.timestamps = true
        settings.filterProfanity = false
        settings.smartFormatting = true

        var callback = RecognizeCallback()
        callback.onError = { error in
            XCTFail(unexpectedErrorMessage(error))
        }
        callback.onResults = { results in
            self.validateSTTResults(results: results, settings: settings)
            XCTAssertNotNil(results.results)
            if results.results!.last?.finalResults == true {
                let transcript = results.results!.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.count, 0)
                expectation.fulfill()
            }
        }
        speechToText.recognizeUsingWebSocket(audio: fileData, settings: settings, model: "en-US_BroadbandModel", learningOptOut: true, callback: callback)
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: - Processing Metrics

    func testTranscribeFileWithProcessingMetricsWAV() {
        transcribeFileWithProcessingMetrics(filename: "SpeechSample", withExtension: "wav", format: "audio/wav")
    }

    func testTranscribeFileWithProcessingMetricsOpus() {
        transcribeFileWithProcessingMetrics(filename: "SpeechSample", withExtension: "ogg", format: "audio/ogg;codecs=opus")
    }

    func testTranscribeFileWithProcessingMetricsFLAC() {
        transcribeFileWithProcessingMetrics(filename: "SpeechSample", withExtension: "flac", format: "audio/flac")
    }

    func testTranscribeFileWithProcessingMetricsNoFormat() {
        transcribeFileWithProcessingMetrics(filename: "SpeechSample", withExtension: "ogg", format: nil)
    }

    func transcribeFileWithProcessingMetrics(filename: String, withExtension: String, format: String?) {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail(cannotLocateFileMessage(filename, withExtension))
            return
        }
        let fileData = try! Data(contentsOf: file)

        var settings = RecognitionSettings(contentType: format)
        settings.processingMetrics = true
        settings.processingMetricsInterval = 0.5
        settings.audioMetrics = true

        var gotProcessingMetrics = false
        var gotAudioMetrics = false
        var callback = RecognizeCallback()
        callback.onError = { error in
            XCTFail(unexpectedErrorMessage(error))
        }
        callback.onResults = { results in
            self.validateSTTResults(results: results, settings: settings)
            if results.processingMetrics != nil {
                gotProcessingMetrics = true
            }
            if results.audioMetrics != nil {
                gotAudioMetrics = true
            }
            // Check final results
            if results.results?.last?.finalResults == true {
                let transcript = results.results!.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.count, 0)
                XCTAssert(gotProcessingMetrics)
                XCTAssert(gotAudioMetrics)
                expectation.fulfill()
            }
        }
        speechToText.recognizeUsingWebSocket(audio: fileData, settings: settings, model: "en-US_BroadbandModel", learningOptOut: true, callback: callback)
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: - Transcribe Data, Default Settings

    func testTranscribeDataDefaultWAV() {
        transcribeDataDefault(filename: "SpeechSample", withExtension: "wav", format: "audio/wav")
    }

    func testTranscribeDataDefaultOpus() {
        transcribeDataDefault(filename: "SpeechSample", withExtension: "ogg", format: "audio/ogg;codecs=opus")
    }

    func testTranscribeDataDefaultFLAC() {
        transcribeDataDefault(filename: "SpeechSample", withExtension: "flac", format: "audio/flac")
    }

    func testTranscribeDataDefaultNoFormat() {
        transcribeDataDefault(filename: "SpeechSample", withExtension: "flac", format: nil)
    }

    func transcribeDataDefault(filename: String, withExtension: String, format: String?) {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail(cannotLocateFileMessage(filename, withExtension))
            return
        }

        do {
            let audio = try Data(contentsOf: file)

            let settings = RecognitionSettings(contentType: format)

            var callback = RecognizeCallback()
            callback.onError = { error in
                XCTFail(unexpectedErrorMessage(error))
            }
            callback.onResults = { results in
                self.validateSTTResults(results: results, settings: settings)
                XCTAssertNotNil(results.results)
                XCTAssertEqual(results.results!.count, 1)
                XCTAssert(results.results!.last?.finalResults == true)
                let transcript = results.results!.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.count, 0)
                expectation.fulfill()
            }
            speechToText.recognizeUsingWebSocket(audio: audio, settings: settings, callback: callback)
            wait(for: [expectation], timeout: timeout)
        } catch {
            XCTFail(cannotReadFileMessage(filename, withExtension))
            return
        }
    }

     // MARK: - Transcribe Data, Custom Settings

    func testTranscribeDataCustomWAV() {
        transcribeDataCustom(filename: "SpeechSample", withExtension: "wav", format: "audio/wav")
    }

    func testTranscribeDataCustomOpus() {
        transcribeDataCustom(filename: "SpeechSample", withExtension: "ogg", format: "audio/ogg;codecs=opus")
    }

    func testTranscribeDataCustomFLAC() {
        transcribeDataCustom(filename: "SpeechSample", withExtension: "flac", format: "audio/flac")
    }

    func testTranscribeDataCustomNoFormat() {
        transcribeDataCustom(filename: "SpeechSample", withExtension: "wav", format: nil)
    }

    func transcribeDataCustom(filename: String, withExtension: String, format: String?) {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail(cannotLocateFileMessage(filename, withExtension))
            return
        }

        do {
            let audio = try Data(contentsOf: file)

            var settings = RecognitionSettings(contentType: format)
            settings.inactivityTimeout = -1
            settings.keywords = ["tornadoes"]
            settings.keywordsThreshold = 0.75
            settings.maxAlternatives = 3
            settings.interimResults = true
            settings.wordAlternativesThreshold = 0.25
            settings.wordConfidence = true
            settings.timestamps = true
            settings.filterProfanity = false
            settings.smartFormatting = true

            var callback = RecognizeCallback()
            callback.onError = { error in
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            callback.onResults = { results in
                self.validateSTTResults(results: results, settings: settings)
                if results.results?.last?.finalResults == true {
                    let transcript = results.results!.last?.alternatives.last?.transcript
                    XCTAssertNotNil(transcript)
                    XCTAssertGreaterThan(transcript!.count, 0)
                    expectation.fulfill()
                }
            }
            speechToText.recognizeUsingWebSocket(audio: audio, settings: settings, model: "en-US_BroadbandModel", learningOptOut: true, callback: callback)
            wait(for: [expectation], timeout: timeout)
        } catch {
            XCTFail(cannotReadFileMessage(filename, withExtension))
            return
        }
    }

    // MARK: - Custom language models, custom acoustic models

    func testRecognizeWithCustomLanguageModel() {
        let filename = "SpeechSample"
        let withExtension = "wav"
        let format = "audio/wav"
        let baseModelName = "en-US_BroadbandModel"

        // find a suitable language model
        var customizationID: String!
        let expectation1 = self.expectation(description: "listLanguageModels")
        speechToText.listLanguageModels(language: "en-US") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            let languageModel = results.customizations.first(where: { model in
                model.baseModelName == baseModelName && model.status == LanguageModel.Status.available.rawValue
            })
            customizationID = languageModel?.customizationID
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // If the create request failed, skip the rest of the test.
        guard customizationID != nil else {
            XCTFail("No suitable language model is available for test")
            return
        }

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }

        do {
            let audio = try Data(contentsOf: file)
            let settings = RecognitionSettings(contentType: format)

            var callback = RecognizeCallback()
            callback.onError = { error in
                XCTFail(unexpectedErrorMessage(error))
            }
            let expectation2 = self.expectation(description: "Recognize with custom language model")
            callback.onResults = { results in
                self.validateSTTResults(results: results, settings: settings)
                XCTAssertNotNil(results.results)
                XCTAssertEqual(results.results!.count, 1)
                XCTAssert(results.results!.last?.finalResults == true)
                let transcript = results.results!.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.count, 0)
                expectation2.fulfill()
            }
            speechToText.recognizeUsingWebSocket(audio: audio, settings: settings, model: baseModelName, languageCustomizationID: customizationID, callback: callback)
            wait(for: [expectation2], timeout: 30)
        } catch {
            XCTFail("Unable to read \(filename).\(withExtension).")
            return
        }
    }

    func testRecognizeWithCustomAcousticModel() {
        let filename = "SpeechSample"
        let withExtension = "wav"
        let format = "audio/wav"
        let baseModelName = "en-US_BroadbandModel"

        // find a suitable acoustic model
        var customizationID: String!
        let expectation1 = self.expectation(description: "listAcousticModels")
        speechToText.listAcousticModels(language: "en-US") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            let acousticModel = results.customizations.first(where: { model in
                model.baseModelName == baseModelName && model.status == AcousticModel.Status.available.rawValue
            })
            customizationID = acousticModel?.customizationID
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // If the create request failed, skip the rest of the test.
        guard customizationID != nil else {
            XCTFail("No suitable acoustic model is available for test")
            return
        }

        let expectation = self.expectation(description: "Recognize with custom language model")
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }

        do {
            let audio = try Data(contentsOf: file)

            let settings = RecognitionSettings(contentType: format)
            var callback = RecognizeCallback()
            callback.onError = { error in
                XCTFail(unexpectedErrorMessage(error))
            }
            callback.onResults = { results in
                self.validateSTTResults(results: results, settings: settings)
                XCTAssertNotNil(results.results)
                XCTAssertEqual(results.results!.count, 1)
                XCTAssert(results.results!.last?.finalResults == true)
                let transcript = results.results!.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.count, 0)
                expectation.fulfill()
            }
            speechToText.recognizeUsingWebSocket(audio: audio, settings: settings, model: baseModelName, acousticCustomizationID: customizationID, callback: callback)
            wait(for: [expectation], timeout: timeout)
        } catch {
            XCTFail("Unable to read \(filename).\(withExtension).")
            return
        }
    }

     // MARK: - Transcribe Data with Smart Formatting

    func testTranscribeStockAnnouncementCustomWAV() {
        transcribeDataCustomForNumbers(
            filename: "StockAnnouncement",
            withExtension: "wav",
            format: "audio/wav",
            substring: "$152.37"
        )
    }

    func transcribeDataCustomForNumbers(filename: String, withExtension: String, format: String, substring: String) {
        let description = "Transcribe an audio file with smart formatting."
        let expectation = self.expectation(description: description)

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail(cannotLocateFileMessage(filename, withExtension))
            return
        }

        guard let audio = try? Data(contentsOf: file) else {
            XCTFail(cannotReadFileMessage(filename, withExtension))
            return
        }

        var settings = RecognitionSettings(contentType: format)
        settings.smartFormatting = true

        var callback = RecognizeCallback()
        callback.onError = { error in
            XCTFail(unexpectedErrorMessage(error))
        }
        callback.onResults = { results in
            self.validateSTTResults(results: results, settings: settings)
            XCTAssertNotNil(results.results)
            if results.results!.last?.finalResults == true {
                let transcript = results.results!.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.count, 0)
                XCTAssertTrue(transcript!.contains(substring))
                expectation.fulfill()
            }
        }

        speechToText.recognizeUsingWebSocket(
            audio: audio,
            settings: settings,
            model: "en-US_BroadbandModel",
            learningOptOut: true,
            callback: callback)

        wait(for: [expectation], timeout: timeout)
    }

    func testTranscribeDataWithSpeakerLabelsWAV() {
        transcribeDataWithSpeakerLabels(filename: "SpeechSample", withExtension: "wav", format: "audio/wav")
    }

    func testTranscribeDataWithSpeakerLabelsOpus() {
        transcribeDataWithSpeakerLabels(filename: "SpeechSample", withExtension: "ogg", format: "audio/ogg;codecs=opus")
    }

    func testTranscribeDataWithSpeakerLabelsFLAC() {
        transcribeDataWithSpeakerLabels(filename: "SpeechSample", withExtension: "flac", format: "audio/flac")
    }

    func testTranscribeDataWithSpeakerLabelsNoFormat() {
        transcribeDataWithSpeakerLabels(filename: "SpeechSample", withExtension: "ogg", format: nil)
    }

    func transcribeDataWithSpeakerLabels(filename: String, withExtension: String, format: String?) {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)
        var expectationFulfilled = false

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail(cannotLocateFileMessage(filename, withExtension))
            return
        }

        do {
            let audio = try Data(contentsOf: file)

            var settings = RecognitionSettings(contentType: format)
            settings.inactivityTimeout = -1
            settings.interimResults = false
            settings.wordConfidence = true
            settings.timestamps = true
            settings.filterProfanity = false
            settings.speakerLabels = true

            var callback = RecognizeCallback()
            callback.onError = { error in
                XCTFail(unexpectedErrorMessage(error))
            }
            callback.onResults = { results in
                XCTAssertNotNil(results.speakerLabels)
                if !expectationFulfilled && results.speakerLabels!.count > 0 {
                    self.validateSTTSpeakerLabels(speakerLabels: results.speakerLabels!)
                    expectationFulfilled = true
                    expectation.fulfill()
                }
            }
            speechToText.recognizeUsingWebSocket(audio: audio, settings: settings, model: "en-US_NarrowbandModel", learningOptOut: true, callback: callback)
            wait(for: [expectation], timeout: timeout)
        } catch {
            XCTFail(cannotReadFileMessage(filename, withExtension))
            return
        }
    }

    // MARK: - callbacks

    func testCallbacks() {
        let filename = "SpeechSample"
        let ext = "wav"

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: ext) else {
            XCTFail(cannotLocateFileMessage(filename, ext))
            return
        }
        let audio = try! Data(contentsOf: file)

        var settings = RecognitionSettings(contentType: "audio/wav")
        settings.inactivityTimeout = 5
        settings.interimResults = false

        let gotResults = self.expectation(description: "onResults received")

        var callback = RecognizeCallback()
        callback.onResults = { results in
            gotResults.fulfill()
        }
        callback.onError = { error in
            XCTFail(unexpectedErrorMessage(error))
        }
        speechToText.recognizeUsingWebSocket(audio: audio, settings: settings, model: "en-US_NarrowbandModel", learningOptOut: true, callback: callback)
        wait(for: [gotResults], timeout: timeout)
    }

    func testErrorCallbacks() {
        let audio = "This is bogus input".data(using: .utf8)!

        var settings = RecognitionSettings(contentType: "audio/wav")
        settings.inactivityTimeout = 5
        settings.interimResults = false

        let gotError = self.expectation(description: "onError received")
        gotError.assertForOverFulfill = false

        var callback = RecognizeCallback()
        callback.onError = { results in
             gotError.fulfill()
        }

        speechToText.recognizeUsingWebSocket(audio: audio, settings: settings, model: "en-US_NarrowbandModel", learningOptOut: true, callback: callback)
        wait(for: [gotError], timeout: timeout)
        // onDisconnected not called because session was freed
    }

    // MARK: - Results Accumulator

    func testResultsAccumulator() {
        let results1 = """
            {
              "results": [{
                "alternatives": [{
                  "transcript": "the quick "
                }],
                "final": false
              }],
              "result_index": 0
            }
            """

        let results2 = """
            {
              "results": [{
                "alternatives": [{
                  "confidence": 0.922,
                  "transcript": "the quick brown fox"
                }],
                "final": true
              }],
              "result_index": 0,
              "speaker_labels": [
                {
                  "from": 0.68,
                  "to": 1.19,
                  "speaker": 2,
                  "confidence": 0.418,
                  "final": false
                },
                {
                  "from": 1.47,
                  "to": 1.93,
                  "speaker": 1,
                  "confidence": 0.521,
                  "final": false
                }
              ]
            }
            """

        let results3 = """
            {
              "results": [{
                "alternatives": [{
                  "confidence": 0.873,
                  "transcript": "jumps over the lazy dog"
                }],
                "final": true
              }],
              "result_index": 1,
              "speaker_labels": [
                {
                  "from": 1.96,
                  "to": 2.59,
                  "speaker": 2,
                  "confidence": 0.418,
                  "final": false
                }
              ]
            }
            """

        var accumulator = SpeechRecognitionResultsAccumulator()
        accumulator.add(results: try! JSONDecoder().decode(SpeechRecognitionResults.self, from: results1.data(using: .utf8)!))
        accumulator.add(results: try! JSONDecoder().decode(SpeechRecognitionResults.self, from: results2.data(using: .utf8)!))
        accumulator.add(results: try! JSONDecoder().decode(SpeechRecognitionResults.self, from: results3.data(using: .utf8)!))

        XCTAssertEqual(accumulator.results.count, 2)
        XCTAssertEqual(accumulator.speakerLabels.count, 3)
        XCTAssertEqual(accumulator.bestTranscript, "the quick brown fox jumps over the lazy dog")
    }

     // MARK: - Transcribe Streaming

    func testTranscribeStreaming() {
        print("")
        print("******************************************************************************")
        print(" WARNING: Cannot test streaming audio in simulator.")
        print(" No audio capture devices are available. Please manually load the test")
        print(" application for streaming audio and run it on a physical device.")
        print("******************************************************************************")
        print("")
    }

     // MARK: - Validation Functions

    func validateSTTResults(results: SpeechRecognitionResults, settings: RecognitionSettings) {
        guard let results = results.results else { return }
        for result in results {
            validateSTTResult(result: result, settings: settings)
        }
    }

    func validateSTTResult(result: SpeechRecognitionResult, settings: RecognitionSettings) {

        XCTAssertNotNil(result.finalResults)
        let final = result.finalResults

        XCTAssertNotNil(result.alternatives)
        var alternativesWithConfidence = 0
        for alternative in result.alternatives {
            if alternative.confidence != nil {
                alternativesWithConfidence += 1
                validateSTTTranscription(transcription: alternative, best: true, final: final, settings: settings)
            } else {
                validateSTTTranscription(transcription: alternative, best: false, final: final, settings: settings)
            }
        }

        if final {
            XCTAssertEqual(alternativesWithConfidence, 1)
        }

        if settings.keywords != nil, settings.keywords!.count > 0 && final {
            XCTAssertNotNil(settings.keywordsThreshold)
            XCTAssertGreaterThanOrEqual(settings.keywordsThreshold!, 0.0)
            XCTAssertLessThanOrEqual(settings.keywordsThreshold!, 1.0)
            XCTAssertNotNil(result.keywordsResult)
            XCTAssertGreaterThan(result.keywordsResult!.count, 0)
            for (keyword, keywordsResult) in result.keywordsResult! {
                validateSTTKeywordsResult(keyword: keyword, keywordsResult: keywordsResult)
            }
        } else {
            let isEmpty = (result.keywordsResult?.count == 0)
            let isNil = (result.keywordsResult == nil)
            XCTAssert(isEmpty || isNil)
        }

        if settings.wordAlternativesThreshold != nil && final {
            XCTAssertNotNil(settings.wordAlternativesThreshold)
            XCTAssertGreaterThanOrEqual(settings.wordAlternativesThreshold!, 0.0)
            XCTAssertLessThanOrEqual(settings.wordAlternativesThreshold!, 1.0)
            XCTAssertNotNil(result.wordAlternatives)
            XCTAssertGreaterThan(result.wordAlternatives!.count, 0)
            for wordAlternatives in result.wordAlternatives! {
                validateSTTWordAlternativeResults(wordAlternatives: wordAlternatives)
            }
        } else {
            let isEmpty = (result.wordAlternatives?.count == 0)
            let isNil = (result.keywordsResult == nil)
            XCTAssert(isEmpty || isNil)
        }
    }

    func validateSTTTranscription(
        transcription: SpeechRecognitionAlternative,
        best: Bool,
        final: Bool,
        settings: RecognitionSettings)
    {
        XCTAssertNotNil(transcription.transcript)
        XCTAssertGreaterThan(transcription.transcript.count, 0)

        if best && final {
            XCTAssertNotNil(transcription.confidence)
            XCTAssertGreaterThanOrEqual(transcription.confidence!, 0.0)
            XCTAssertLessThanOrEqual(transcription.confidence!, 1.0)
        } else {
            XCTAssertNil(transcription.confidence)
        }

        if settings.timestamps == true && (!final || best) {
            XCTAssertNotNil(transcription.timestamps)
            XCTAssertGreaterThan(transcription.timestamps!.count, 0)
            for timestamp in transcription.timestamps! {
                validateSTTWordTimestamp(timestamp: timestamp)
            }
        } else {
            let isEmpty = (transcription.timestamps?.count == 0)
            let isNil = (transcription.timestamps == nil)
            XCTAssert(isEmpty || isNil)
        }

        if settings.wordConfidence == true && final && best {
            XCTAssertNotNil(transcription.wordConfidence)
            XCTAssertGreaterThan(transcription.wordConfidence!.count, 0)
            for word in transcription.wordConfidence! {
                validateSTTWordConfidence(word: word)
            }
        } else {
            let isEmpty = (transcription.wordConfidence?.count == 0)
            let isNil = (transcription.wordConfidence == nil)
            XCTAssert(isEmpty || isNil)
        }
    }

    func validateSTTWordTimestamp(timestamp: WordTimestamp) {
        XCTAssertGreaterThan(timestamp.word.count, 0)
        XCTAssertGreaterThanOrEqual(timestamp.startTime, 0.0)
        XCTAssertGreaterThanOrEqual(timestamp.endTime, timestamp.startTime)
    }

    func validateSTTWordConfidence(word: WordConfidence) {
        XCTAssertGreaterThan(word.word.count, 0)
        XCTAssertGreaterThanOrEqual(word.confidence, 0.0)
        XCTAssertLessThanOrEqual(word.confidence, 1.0)
    }

    func validateSTTKeywordsResult(keyword: String, keywordsResult: [KeywordResult]) {
        XCTAssertGreaterThan(keyword.count, 0)
        XCTAssertGreaterThan(keywordsResult.count, 0)
        for keywordsResult in keywordsResult {
            validateSTTKeywordResult(keywordResult: keywordsResult)
        }
    }

    func validateSTTKeywordResult(keywordResult: KeywordResult) {
        XCTAssertGreaterThan(keywordResult.normalizedText.count, 0)
        XCTAssertGreaterThanOrEqual(keywordResult.startTime, 0)
        XCTAssertGreaterThanOrEqual(keywordResult.endTime, keywordResult.startTime)
        XCTAssertGreaterThanOrEqual(keywordResult.confidence, 0.0)
        XCTAssertLessThanOrEqual(keywordResult.confidence, 1.0)
    }

    func validateSTTWordAlternativeResults(wordAlternatives: WordAlternativeResults) {
        XCTAssertGreaterThanOrEqual(wordAlternatives.startTime, 0.0)
        XCTAssertGreaterThanOrEqual(wordAlternatives.endTime, wordAlternatives.startTime)
        XCTAssertGreaterThan(wordAlternatives.alternatives.count, 0)
        for wordAlternative in wordAlternatives.alternatives {
            validateSTTWordAlternativeResult(wordAlternative: wordAlternative)
        }
    }

    func validateSTTWordAlternativeResult(wordAlternative: WordAlternativeResult) {
        XCTAssertGreaterThanOrEqual(wordAlternative.confidence, 0.0)
        XCTAssertLessThanOrEqual(wordAlternative.confidence, 1.0)
        XCTAssertGreaterThan(wordAlternative.word.count, 0)
    }

    func validateSTTSpeakerLabels(speakerLabels: [SpeakerLabelsResult]) {
        XCTAssertGreaterThan(speakerLabels.count, 0)
        for speakerLabel in speakerLabels {
            validateSTTSpeakerLabel(speakerLabel: speakerLabel)
        }
    }

    func validateSTTSpeakerLabel(speakerLabel: SpeakerLabelsResult) {
        XCTAssertGreaterThanOrEqual(speakerLabel.from, 0)
        XCTAssertGreaterThanOrEqual(speakerLabel.to, 0)
        XCTAssertGreaterThanOrEqual(speakerLabel.confidence, 0.0)
        XCTAssertLessThanOrEqual(speakerLabel.confidence, 1.0)
        XCTAssertGreaterThanOrEqual(speakerLabel.speaker, 0)
    }
}

#endif
