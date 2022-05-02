# Shortly
## Mobile Application To Shorten URLs
URL shortening is a technique on the Web in which a Uniform Resource Locator (URL) may be made substantially shorter and still direct to the required page. This is achieved by using a redirect that links to the web page that has a long URL. For example, the URL ```https://example.com/assets/category_B/subcategory_C/Foo/``` can be shortened to ```https://example.com/Foo```, and the URL ```http://example.com/about/index.html``` can be shortened to ```https://goo.gl/aO3Ssc```.
## Features

- Shorten Urls with using "shrtco" api
- It store short url history on Local Storage

## Tech

- [Flutter] - Build apps for any screen!

## Installation

```
flutter pub get
```

For LCOV Code Coverage Report ...
Firstly install LCOV to Global

```
 brew install lcov
```

## Run

```
 flutter run
```

## Test

Before start the tests, please run build_runner to generate mock files
```
 flutter pub run build_runner build
```

Test
```
 flutter test
```

Coverage Test
```
 flutter test --coverage
```

Coverage Test with LCOV report
```
 flutter test --coverage &&  genhtml coverage/lcov.info -o coverage/html
```

**note**: Coverage report will be located under ```coverage/html/index.html``` directory.

### Case Reference
```https://github.com/grisoftware/shortly-challange```