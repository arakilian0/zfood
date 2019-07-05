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

#if os(iOS) || os(tvOS) || os(watchOS)

import XCTest
import Foundation
import UIKit
import VisualRecognitionV3

class VisualRecognitionUIImageTests: XCTestCase {

    private var visualRecognition: VisualRecognition!
    private let classifierID = WatsonCredentials.VisualRecognitionClassifierID

    private var car: UIImage {
        let bundle = Bundle(for: type(of: self))
        let file = bundle.url(forResource: "car", withExtension: "png")!
        return UIImage(contentsOfFile: file.path)!
    }

    private var obama: UIImage {
        let bundle = Bundle(for: type(of: self))
        let file = bundle.url(forResource: "obama", withExtension: "jpg")!
        return UIImage(contentsOfFile: file.path)!
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateVisualRecognition()
    }

    func instantiateVisualRecognition() {
        guard let apiKey = WatsonCredentials.VisualRecognitionAPIKey else {
            XCTFail("Missing credentials for Visual Recognition service")
            return
        }
        visualRecognition = VisualRecognition(version: versionDate, apiKey: apiKey)
        if let url = WatsonCredentials.VisualRecognitionURL {
            visualRecognition.serviceURL = url
        }
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"
    }

    func waitForExpectations(timeout: TimeInterval = 15.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    func testClassifyUIImage() {
        let expectation = self.expectation(description: "Classify a UIImage using the default classifier.")
        visualRecognition.classify(image: car, acceptLanguage: "en") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            var containsPersonClass = false
            var classifierScore: Double?
            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertNil(image?.sourceURL)
            XCTAssertNil(image?.resolvedURL)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, "default")
            XCTAssertEqual(classifier?.name, "default")
            guard let classes = classifier?.classes else {
                XCTFail("Did not return any classes")
                return
            }
            XCTAssertGreaterThan(classes.count, 0)
            for cls in classes where cls.className == "car" {
                containsPersonClass = true
                classifierScore = cls.score
                break
            }
            XCTAssertEqual(true, containsPersonClass)
            if let score = classifierScore {
                XCTAssertGreaterThan(score, 0.5)
            }

            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testDetectFacesByUIImage() {
        let expectation = self.expectation(description: "Detect faces in a UIImage.")
        visualRecognition.detectFaces(image: obama) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let faceImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify face images object
            XCTAssertEqual(faceImages.imagesProcessed, 1)
            XCTAssertNil(faceImages.warnings)
            XCTAssertEqual(faceImages.images.count, 1)

            // verify the face image object
            let face = faceImages.images.first
            XCTAssertNil(face?.sourceURL)
            XCTAssertNil(face?.resolvedURL)
            XCTAssertNotNil(face?.image)
            XCTAssertNil(face?.error)
            XCTAssertEqual(face?.faces.count, 1)

            // verify the age
            let age = face?.faces.first?.age
            XCTAssertGreaterThanOrEqual(age!.min!, 40)
            XCTAssertLessThanOrEqual(age!.max!, 54)
            XCTAssertGreaterThanOrEqual(age!.score, 0.25)

            // verify the face location
            let location = face?.faces.first?.faceLocation
            XCTAssertEqual(location?.height, 172)
            XCTAssertEqual(location?.left, 219)
            XCTAssertEqual(location?.top, 79)
            XCTAssertEqual(location?.width, 141)

            // verify the gender
            let gender = face?.faces.first?.gender
            XCTAssertEqual(gender!.gender, "MALE")
            XCTAssertGreaterThanOrEqual(gender!.score, 0.75)

            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyWithLocalModel() {
        if #available(iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            // update the local model
            let expectation1 = self.expectation(description: "updateLocalModel")
            visualRecognition.updateLocalModel(classifierID: classifierID) {
                _, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }

                expectation1.fulfill()
            }
            waitForExpectations()

            // classify using the local model
            let expectation2 = self.expectation(description: "classifyWithLocalModel")
            let image = UIImage(named: "car", in: Bundle(for: type(of: self)), compatibleWith: nil)!
            visualRecognition.classifyWithLocalModel(image: image, classifierIDs: [classifierID], threshold: 0.1) {
                classifiedImages, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let classifiedImages = classifiedImages else {
                    XCTFail(missingResultMessage)
                    return
                }

                print(classifiedImages)
                expectation2.fulfill()
            }
            waitForExpectations()

            // delete the local model
            do {
                try visualRecognition.deleteLocalModel(classifierID: classifierID)
            } catch {
                XCTFail("Failed to delete the local model: \(error)")
            }

        }
    }
}

#endif
