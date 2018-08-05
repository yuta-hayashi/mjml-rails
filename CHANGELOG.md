## 4.2.1

* Implemented Aleksandrs Ļedovskis' fix for Haml/Slim layouts.

## 4.2.0

* Aleksandrs Ļedovskis refactored MJML layout/template support to better match Rails standards.

## 4.1.0

* Ryan Ahearn updated for 4.1.0 and improved Tempfile usage.

## 4.0.3

* Anh Tran added the use of Open3.popen3 to support error raising for Mjml::Parse#run method.

## 4.0.2

* Max Mulatz, 🧟‍ squisher. Fixed a zombie process from the version checker (also cutest pull-request 🏆).

## 4.0.1

* Option to raise render errors added to the config by Anh Tran.

## 4.0.0

* Updated for MJML v4.0.0 thanks to JP Boily.

## 2.4.3

* Checks if Yarn is installed for webpacker users.

## 2.4.2

* Only raise error when really using mjml if binary is not found.

## 2.4.1

* Using IO.popen from tylerhunt's branch to check if the MJML binary is installed.

## 2.3.0

* Updated to support HAML and other template languages.

## 2.2.0

* Updated to work with MJML v2.x
* Performing executable checks and version checks at initialize time.

## 2.1.4.1

* Removing require: 'mjml' from the Gemfile install line.

## 2.1.4

* Updated to MJML v2.1.4

## 2.1.1

* Supports new tags in MJML v2.1.1
* Version number now matches MJML.io version

## 1.0.0

* First release.
* Supports MJML 1.x
* Allows use of ERb in templates
* Allows use of partials in templates

