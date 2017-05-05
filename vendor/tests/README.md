# Microformats test suite

This group of tests was built to test microformats parsers. The individual tests are files containing fragments of HTML.  There is also a second a corresponding JSON file, which contains the expected output. 

The tests are broken into sets within the tests directory of this project. They are first grouped by version. Some parsers only support a single version of microformats. They are then subdivided by the type of microformat i.e. h-card.


## NPM

The test have been added to npm (Node Package Manager) and the latest version can be add to a project using the following command:

    npm i microformat-tests --save


## Contributing new tests or updating tests

This set of test belongs to the microformats community. If you find any errors in the current test or new patterns you believe should be in the test suite please feel free to send a pull request. 

Notes on creating a new test

A test is built in two parts a HTML file, which contains a fragment of HTML to parse, and JSON file with the expected output from a parser.

1. Within the “test” directory of this project select the correct directory for the version of microformats the test belongs to. If you are creating a test for a new microformats feature or exploring an issue please add these tests to the “experimental” directory.

2. Within the correct directory add your new test to subdirecory with either the name of it format i.e. `h-card` or the name of the new feature.

3. Create the HTML file. Add the smallest and clearest example of the markup you can. There is no need to add head or body tags etc.

4. Create a JSON file with the same name as your HTML file. The JSON should be the expected output from a parser.

5. Once you have created the test please update the change-log.html Add a `h-entry` with details of the test . At the bottom of the page please add yourself as a contributor on the authors list


## Date format for testing purposes

Within the tests datetime formats are based on the [HTML5 profile](http://www.w3.org/TR/html5/infrastructure.html#dates-and-times) which is a subset of ISO8601 and allows a space to separate the date and time. To allow us to compare dates please provide a way for your parser to output dates/times with the follwing rules:

* Date and time are separated by a spaces ie `2015-04-29 15:34`
* Date and time keeps the authored level of specificity  ie `15:34` does NOT become `15:34:00`
* Times and timezones always use the `:` separator ie `+01:30` NOT `+0130`
* If used the zulu is always uppercase ie `2015-04-29 15:34Z`


## License

**Microformats test suite** is dedicated to the public domain using Creative Commons -- CC0 1.0 Universal.

http://creativecommons.org/publicdomain/zero/1.0
