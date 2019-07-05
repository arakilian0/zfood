/**
 * (C) Copyright IBM Corp. 2017, 2019.
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
import NaturalLanguageUnderstandingV1
import RestKit

class NaturalLanguageUnderstandingTests: XCTestCase {

    private var naturalLanguageUnderstanding: NaturalLanguageUnderstanding!
    private let text = "In 2009, Elliot Turner launched AlchemyAPI to process the written word, with all of its quirks and nuances, and got immediate traction."
    private let url = "http://www.politico.com/story/2016/07/dnc-2016-obama-prepared-remarks-226345"
    private var html: String!

    override func setUp() {
        super.setUp()
        instantiateNaturalLanguageUnderstanding()
        loadHTML()
    }

    static var allTests: [(String, (NaturalLanguageUnderstandingTests) -> () throws -> Void)] {
        return [
            ("testAnalyzeHTML", testAnalyzeHTML),
            ("testAnalyzeText", testAnalyzeText),
            ("testAnalyzeURL", testAnalyzeURL),
            ("testAnalyzeTextForConcepts", testAnalyzeTextForConcepts),
            ("testAnalyzeHTMLForConcepts", testAnalyzeHTMLForConcepts),
            ("testAnalyzeTextForEmotions", testAnalyzeTextForEmotions),
            ("testAnalyzeTextForEmotionsWithoutTargets", testAnalyzeTextForEmotionsWithoutTargets),
            ("testAnalyzeTextForEntities", testAnalyzeTextForEntities),
            ("testAnalyzeTextForKeywords", testAnalyzeTextForKeywords),
            ("testAnalyzeHTMLForMetadata", testAnalyzeHTMLForMetadata),
            ("testAnalyzeTextForRelations", testAnalyzeTextForRelations),
            ("testAnalyzeTextForSemanticRoles", testAnalyzeTextForSemanticRoles),
            ("testAnalyzeTextForSentiment", testAnalyzeTextForSentiment),
            ("testAnalyzeTextForSentimentWithoutTargets", testAnalyzeTextForSentimentWithoutTargets),
            ("testAnalyzeTextForCategories", testAnalyzeTextForCategories),
            ("testCustomModel", testCustomModel),
            ("testDeleteModel", testDeleteModel),
            ("testListModels", testListModels),
        ]
    }

    /** Instantiate Natural Language Understanding instance. */
    func instantiateNaturalLanguageUnderstanding() {
        if let apiKey = WatsonCredentials.NaturalLanguageUnderstandingAPIKey {
            naturalLanguageUnderstanding = NaturalLanguageUnderstanding(version: versionDate, apiKey: apiKey)
        } else {
            let username = WatsonCredentials.NaturalLanguageUnderstandingUsername
            let password = WatsonCredentials.NaturalLanguageUnderstandingPassword
            naturalLanguageUnderstanding = NaturalLanguageUnderstanding(version: versionDate, username: username, password: password)
        }
        if let url = WatsonCredentials.NaturalLanguageUnderstandingURL {
            naturalLanguageUnderstanding.serviceURL = url
        }
        naturalLanguageUnderstanding.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        naturalLanguageUnderstanding.defaultHeaders["X-Watson-Test"] = "true"
    }

    func loadHTML() {
        #if os(Linux)
            let file = URL(fileURLWithPath: "Tests/NaturalLanguageUnderstandingV1Tests/testArticle.html").path
            html = try! String(contentsOfFile: file, encoding: .utf8)
        #else
            let bundle = Bundle(for: type(of: self))
            guard let file = bundle.path(forResource: "testArticle", ofType: "html") else {
                XCTFail("Unable to locate testArticle.html")
                return
            }
        html = try! String(contentsOfFile: file)
        #endif
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 5.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive tests

    /** Default test for HTML input. */
    func testAnalyzeHTML() {
        let description = "Analyze HTML."
        let expectation = self.expectation(description: description)
        let concepts = ConceptsOptions(limit: 5)
        let features = Features(concepts: concepts)
        naturalLanguageUnderstanding.analyze(features: features, html: html) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Default test for text input. */
    func testAnalyzeText() {
        let description = "Analyze text with no features."
        let expectation = self.expectation(description: description)
        let concepts = ConceptsOptions(limit: 5)
        let features = Features(concepts: concepts)
        naturalLanguageUnderstanding.analyze(features: features, text: text) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Default test for URL. */
    func testAnalyzeURL() {
        let description = "Analyze URL with no features."
        let expectation = self.expectation(description: description)
        let concepts = ConceptsOptions(limit: 5)
        let features = Features(concepts: concepts)
        naturalLanguageUnderstanding.analyze(features: features, url: url, returnAnalyzedText: true) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze given test input text for concepts. */
    func testAnalyzeTextForConcepts() {
        let description = "Analyze text with features."
        let expectation = self.expectation(description: description)
        let text = """
            In remote corners of the world, citizens are demanding respect for the dignity of all people no matter their
            gender, or race, or religion, or disability, or sexual orientation, and those who deny others dignity are subject
            to public reproach. An explosion of social media has given ordinary people more ways to express themselves,
            and has raised people's expectations for those of us in power. Indeed, our international order has been so
            successful that we take it as a given that great powers no longer fight world wars; that the end of the Cold
            War lifted the shadow of nuclear Armageddon; that the battlefields of Europe have been replaced by peaceful
            union; that China and India remain on a path of remarkable growth.
        """
        let concepts = ConceptsOptions(limit: 5)
        let features = Features(concepts: concepts)
        naturalLanguageUnderstanding.analyze(features: features, text: text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, text)
            guard let concepts = results.concepts else {
                XCTAssertNil(results.concepts)
                return
            }
            for concept in concepts {
                XCTAssertNotNil(concept.text)
                XCTAssertNotNil(concept.dbpediaResource)
                XCTAssertNotNil(concept.relevance)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze test HTML for concepts. */
    func testAnalyzeHTMLForConcepts() {
        let description = "Analyze HTML for concepts."
        let expectation = self.expectation(description: description)
        let features = Features(concepts: ConceptsOptions())
        naturalLanguageUnderstanding.analyze(features: features, html: html, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(results.analyzedText)
            XCTAssertNotNil(results.concepts)
            guard let concepts = results.concepts else {
                XCTAssertNil(results.concepts)
                return
            }
            for concept in concepts {
                XCTAssertNotNil(concept.text)
                XCTAssertNotNil(concept.dbpediaResource)
                XCTAssertNotNil(concept.relevance)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze input text for emotions. */
    func testAnalyzeTextForEmotions() {
        let description = "Analyze text for emotions."
        let expectation = self.expectation(description: description)
        let text = "But I believe this thinking is wrong. I believe the road of true democracy remains the better path. "
                 + "I believe that in the 21st century, economies can only grow to a certain point until they need to open up -- "
                 + "because entrepreneurs need to access information in order to invent; young people need a global education "
                 + "in order to thrive; independent media needs to check the abuses of power."
        let emotion = EmotionOptions(targets: ["democracy", "entrepreneurs", "media", "economies"])
        let features = Features(emotion: emotion)
        naturalLanguageUnderstanding.analyze(features: features, text: text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, text)
            guard let emotion = results.emotion else {
                XCTAssertNil(results.emotion)
                return
            }
            XCTAssertNotNil(emotion.document)
            guard let targets = emotion.targets else {
                XCTAssertNil(emotion.targets)
                return
            }
            for target in targets {
                XCTAssertNotNil(target.text)
                guard let emotion = target.emotion else {
                    XCTAssertNil(target.emotion)
                    return
                }
                XCTAssertNotNil(emotion.anger)
                XCTAssertNotNil(emotion.disgust)
                XCTAssertNotNil(emotion.fear)
                XCTAssertNotNil(emotion.joy)
                XCTAssertNotNil(emotion.sadness)
                break
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze input text for emotions. */
    func testAnalyzeTextForEmotionsWithoutTargets() {
        let description = "Analyze text for emotions without targets."
        let expectation = self.expectation(description: description)
        let text = "But I believe this thinking is wrong. I believe the road of true democracy remains the better path. "
                 + "I believe that in the 21st century, economies can only grow to a certain point until they need to open up -- "
                 + "because entrepreneurs need to access information in order to invent; young people need a global education "
                 + "in order to thrive; independent media needs to check the abuses of power."
        let features = Features(emotion: EmotionOptions())
        naturalLanguageUnderstanding.analyze(features: features, text: text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, text)
            guard let emotionResults = results.emotion else {
                XCTAssertNil(results.emotion)
                return
            }
            XCTAssertNotNil(emotionResults.document)
            guard let documentEmotion = emotionResults.document?.emotion else {
                XCTAssertNil(emotionResults.document?.emotion)
                return
            }
            XCTAssertNotNil(documentEmotion.anger)
            XCTAssertNotNil(documentEmotion.disgust)
            XCTAssertNotNil(documentEmotion.fear)
            XCTAssertNotNil(documentEmotion.joy)
            XCTAssertNotNil(documentEmotion.sadness)
            XCTAssertNil(emotionResults.targets)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze input text for entities. */
    func testAnalyzeTextForEntities() {
        let description = "Analyze text for entities and its corresponding sentiment values."
        let expectation = self.expectation(description: description)
        let features = Features(entities: EntitiesOptions(limit: 2, sentiment: true))
        naturalLanguageUnderstanding.analyze(features: features, text: self.text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, self.text)
            guard let entityResults = results.entities else {
                XCTAssertNil(results.entities)
                return
            }
            XCTAssertEqual(2, entityResults.count)
            for result in entityResults {
                XCTAssertNotNil(result.count)
                XCTAssertNotNil(result.relevance)
                XCTAssertNotNil(result.text)
                XCTAssertNotNil(result.type)
                XCTAssertNotNil(result.sentiment)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze input text for keywords. */
    func testAnalyzeTextForKeywords() {
        let description = "Analyze text for keywords and its corresponding sentiment values."
        let expectation = self.expectation(description: description)
        let features = Features(keywords: KeywordsOptions(sentiment: true))
        naturalLanguageUnderstanding.analyze(features: features, text: self.text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, self.text)
            guard let keywords = results.keywords else {
                XCTAssertNil(results.keywords)
                return
            }
            for keyword in keywords {
                XCTAssertNotNil(keyword.relevance)
                XCTAssertNotNil(keyword.text)
                XCTAssertNotNil(keyword.sentiment)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze html input for metadata. */
    func testAnalyzeHTMLForMetadata() {
        let description = "Analyze html for metadata."
        let expectation = self.expectation(description: description)
        let features = Features(metadata: MetadataOptions())
        let fileTitle = "This 5,000-year-old recipe for beer actually sounds pretty tasty"
        let fileDate = "2016-05-23T20:13:00"
        let fileAuthor = "Annalee Newitz"
        naturalLanguageUnderstanding.analyze(features: features, html: html, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.language, "en")
            XCTAssertEqual(results.metadata?.title, fileTitle)
            XCTAssertEqual(results.metadata?.publicationDate, fileDate)
            XCTAssertEqual(results.metadata?.authors?.count, 1)
            XCTAssertEqual(results.metadata?.authors?.first?.name, fileAuthor)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze input text for relations. */
    func testAnalyzeTextForRelations() {
        let description = "Analyze text for relations."
        let expectation = self.expectation(description: description)
        let features = Features(relations: RelationsOptions())
        naturalLanguageUnderstanding.analyze(features: features, text: self.text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, self.text)
            XCTAssertEqual(results.language, "en")
            XCTAssertNotNil(results.relations)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze input text for semantic roles. */
    func testAnalyzeTextForSemanticRoles() {
        let description = "Analyze text and verify semantic roles returned."
        let expectation = self.expectation(description: description)
        let semanticRoles = SemanticRolesOptions(limit: 7, keywords: true, entities: true)
        let features = Features(semanticRoles: semanticRoles)
        naturalLanguageUnderstanding.analyze(features: features, text: text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, self.text)
            XCTAssertEqual(results.language, "en")
            XCTAssertNotNil(results.semanticRoles)
            for semanticRole in results.semanticRoles! {
                XCTAssertEqual(semanticRole.sentence, self.text)
                if let subject = semanticRole.subject {
                    XCTAssertNotNil(subject.text)
                }
                if let action = semanticRole.action {
                    XCTAssertNotNil(action.text)
                }
                if let object = semanticRole.object {
                    XCTAssertNotNil(object.text)
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze input text for sentiment with targets. */
    func testAnalyzeTextForSentiment() {
        let description = "Analyze text and verify sentiment returned."
        let expectation = self.expectation(description: description)
        let features = Features(sentiment: SentimentOptions(document: true, targets: ["Elliot Turner", "traction"]))
        naturalLanguageUnderstanding.analyze(features: features, text: text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, self.text)
            XCTAssertEqual(results.language, "en")
            XCTAssertNotNil(results.sentiment)
            XCTAssertNotNil(results.sentiment?.document)
            XCTAssertNotNil(results.sentiment?.document?.score)
            XCTAssertNotNil(results.sentiment?.targets)
            for target in (results.sentiment?.targets)! {
                XCTAssertNotNil(target.text)
                XCTAssertNotNil(target.score)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze input text for sentiment without targets. */
    func testAnalyzeTextForSentimentWithoutTargets() {
        let description = "Analyze text and verify sentiment returned."
        let expectation = self.expectation(description: description)
        let features = Features(sentiment: SentimentOptions(document: true))
        naturalLanguageUnderstanding.analyze(features: features, text: text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, self.text)
            XCTAssertEqual(results.language, "en")
            XCTAssertNotNil(results.sentiment)
            XCTAssertNotNil(results.sentiment?.document)
            XCTAssertNotNil(results.sentiment?.document?.score)
            XCTAssertNil(results.sentiment?.targets)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze input text for categories. */
    func testAnalyzeTextForCategories() {
        let description = "Analyze text and verify categories returned."
        let expectation = self.expectation(description: description)
        let features = Features(categories: CategoriesOptions(explanation: true))
        naturalLanguageUnderstanding.analyze(features: features, text: text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, self.text)
            XCTAssertEqual(results.language, "en")
            XCTAssertNotNil(results.categories)
            for category in results.categories! {
                XCTAssertNotNil(category.label)
                XCTAssertNotNil(category.score)
                XCTAssertNotNil(category.explanation?.relevantText)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCustomModel() {
        let description = "Test a custom model."
        let expectation = self.expectation(description: description)
        let features = Features(
            concepts: ConceptsOptions(limit: 5),
            emotion: EmotionOptions(document: true, targets: ["happy"]),
            entities: EntitiesOptions(limit: 5, mentions: true, model: "en-news", sentiment: true, emotion: true),
            keywords: KeywordsOptions(limit: 5, sentiment: true, emotion: true),
            relations: RelationsOptions(model: "en-news"),
            semanticRoles: SemanticRolesOptions(limit: 5, keywords: true, entities: true),
            sentiment: SentimentOptions(document: true, targets: ["happy"]),
            categories: CategoriesOptions()
        )
        naturalLanguageUnderstanding.analyze(features: features, text: text, returnAnalyzedText: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(results.analyzedText, self.text)
            XCTAssertEqual(results.language, "en")
            XCTAssertNotNil(results.entities)
            XCTAssert(results.entities!.map({$0.type!}).contains("Person"))
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testDeleteModel() {
        let description = "Delete an invalid model."
        let expectation = self.expectation(description: description)
        naturalLanguageUnderstanding.deleteModel(modelID: "invalid_model_id") {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListModels() {
        let description = "List available models from Watson Knowledge Studio."
        let expectation = self.expectation(description: description)
        naturalLanguageUnderstanding.listModels {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let results = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(results.models)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
}
