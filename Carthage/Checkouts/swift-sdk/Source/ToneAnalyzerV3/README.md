# Tone Analyzer

The IBM Watson Tone Analyzer service can be used to discover, understand, and revise the language tones in text. The service uses linguistic analysis to detect three types of tones from written text: emotions, social tendencies, and writing style.

Emotions identified include things like anger, fear, joy, sadness, and disgust. Identified social tendencies include things from the Big Five personality traits used by some psychologists. These include openness, conscientiousness, extraversion, agreeableness, and emotional range. Identified writing styles include confident, analytical, and tentative.

The following example demonstrates how to use the Tone Analyzer service:

```swift
import ToneAnalyzerV3

let apiKey = "your-api-key"
let version = "YYYY-MM-DD" // use today's date for the most recent version
let toneAnalyzer = ToneAnalyzer(version: version, apiKey: apiKey)

let input = ToneInput(text: "your-input-text")
toneAnalyzer.tone(toneContent: .toneInput(input)) { response, error in
	if let error = error {
        print(error)
    }
    guard let tones = response?.result else {
        print("Failed to analyze the tone input")
        return
    }
    print(tones)
}
```

The following links provide more information about the IBM Watson Tone Analyzer service:

* [IBM Watson Tone Analyzer - Service Page](https://www.ibm.com/watson/services/tone-analyzer/)
* [IBM Watson Tone Analyzer - Documentation](https://cloud.ibm.com/docs/services/tone-analyzer/index.html)
* [IBM Watson Tone Analyzer - Demo](https://tone-analyzer-demo.ng.bluemix.net/)
