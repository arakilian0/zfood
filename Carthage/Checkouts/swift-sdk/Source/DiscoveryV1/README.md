# Discovery

IBM Watson Discovery makes it possible to rapidly build cognitive, cloud-based exploration applications that unlock actionable insights hidden in unstructured data — including your own proprietary data, as well as public and third-party data. With Discovery, it only takes a few steps to prepare your unstructured data, create a query that will pinpoint the information you need, and then integrate those insights into your new application or existing solution.

## Discovery News

IBM Watson Discovery News is included with Discovery. Watson Discovery News is an indexed dataset with news articles from the past 60 days — approximately 300,000 English articles daily. The dataset is pre-enriched with the following cognitive insights: Keyword Extraction, Entity Extraction, Semantic Role Extraction, Sentiment Analysis, Relation Extraction, and Category Classification.

The following example shows how to query the Watson Discovery News dataset:

```swift
import DiscoveryV1

let apiKey = "your-api-key"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let discovery = Discovery(version: version, apiKey: apiKey)

discovery.query(
    environmentID: "system",
    collectionID: "news-en",
    query: "enriched_text.concepts.text:\"Cloud computing\"") { response, error in

    if let error = error {
        print(error)
    }
    guard let queryResponse = response?.result else {
        print("Failed to get the query response")
        return
    }
    print(queryResponse)
}
```

## Private Data Collections

The Swift SDK supports environment management, collection management, and document uploading. But you may find it easier to create private data collections using the [Discovery Tooling](https://cloud.ibm.com/docs/services/discovery/getting-started-tool.html#getting-started-with-the-tooling) instead.

Once your content has been uploaded and enriched by the Discovery service, you can search the collection with queries. The following example demonstrates a complex query with a filter, query, and aggregation:

```swift
import DiscoveryV1

let apiKey = "your-api-key"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let discovery = Discovery(version: version, apiKey: apiKey)

discovery.query(
    environmentID: "your-environment-id",
    collectionID: "your-collection-id",
    filter: "enriched_text.concepts.text:\"Technology\"",
    query: "enriched_text.concepts.text:\"Cloud computing\"",
    aggregation: "term(enriched_text.concepts.text,count:10)") { response, error in

    if let error = error {
        print(error)
    }
    guard let queryResponse = response?.result else {
        print("Failed to get the query response")
        return
    }
    print(queryResponse)
}
```

You can also upload new documents into your private collection:

```swift
import DiscoveryV1

let apiKey = "your-api-key"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let discovery = Discovery(version: version, apiKey: apiKey)

let file = Bundle.main.url(forResource: "KennedySpeech", withExtension: "html")!
discovery.addDocument(
    environmentID: "your-environment-id",
    collectionID: "your-collection-id",
    file: file,
    fileContentType: "text/html") { response, error in

    if let error = error {
        print(error)
    }
    guard let document = response?.result else {
        print("Failed to add the document")
        return
    }
    print(document)
}
```

The following links provide more information about the IBM Discovery service:

* [IBM Discovery - Service Page](https://www.ibm.com/watson/services/discovery/)
* [IBM Discovery - Documentation](https://cloud.ibm.com/docs/services/discovery/index.html)
* [IBM Discovery - Demo](https://discovery-news-demo.ng.bluemix.net/)
