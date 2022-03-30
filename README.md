# eloit
Ranking through comparison

## Summary
Eloit is a social platform aiming to rank things by comparison. It is a term project for Yale's CPSC 439 by Xinli, Harry, Jack, Yofti, Revant, and Kevin.

## CI/CD Workflow
Our project, while primarily a mobile application, has a corresponding web version that is hosted via Firebase hosting at [eloit-c4540.web.app](eloit-c4540.web.app). On pushes and pull requests to `main`, our `test-and-deploy.yml` workflow gets the required packages using `flutter pub get`, tests the application according to the tests in the `test` and `integration_test` folders using `flutter test`, builds the web application with `flutter build web`, and then automatically deploys the web version on our hosted URL (much more detail on our workflow as well are many more tests to come in the next few days).
