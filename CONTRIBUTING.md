# Contributing

## Git Workflow
This project will follow the [Gitflow Workflow].

## Pull Request Process
1. When your feature/fix is complete create a pull request to merge your branch
into `develop`
2. Use a title that reflects the work done and a summary to give context on the change [^2].
  If it is a visual change, including a screenshot may be helpful.
3. Request the review of relevant developers. A minimum of two approving reviews
  are required.

## Styleguides
### Git Commit Messages [^1]
1. Separate subject from body with a blank line
2. Limit the subject line to 72 characters or less
3. Capitalize the subject line
4. Do not end the subject line with a period
5. Use the present tense ("Add feature" not "Added feature") in the subject line
6. Wrap the body at 72 characters
7. Use the body to explain what and why vs. how

### Branch Names
Branch names should use the following conventions:
- Lower case
- Words hyphen separated
- Short but descriptive
- Appended with `-#<issue_number>` if it relates to an existing issue.

For example `my-new-feature-#62` or `fix-links`

### Angular Style Guide
- The [Angular Style Guide] will be followed for [docks-ui]

### JavaScript Style Guide
- [eslint-config-google] combined with [ESLint recommended rules] will be used for [docks-api]

## Team Structure
The team consists of 6 members and have been allocated between [docks-ui]
and [docks-api]. Team members will primarily focus on their assigned repository
but are encouraged to contribute to the other repositories as well.

Team [docks-ui]:
  - [@annamarieHelberg](https://github.com/annamarieHelberg)
  - [@CDuPlooy](https://github.com/CDuPlooy)
  - [@FJMentz](https://github.com/FJMentz)
  - [@Paulo-W](https://github.com/Paulo-W)

Team [docks-api]:
  - [@devosray](https://github.com/devosray)
  - [@egeldenhuys](https://github.com/egeldenhuys)

## Testing
- Unit tests should accompany all code and is to be written by the developer implementing the feature/fix.

## Commit Squashing
Due to external requirements commits will and should not be squashed.
However please squash "Oops, fix typo" commits if they are not public history.

[^1]: https://chris.beams.io/posts/git-commit/
[^2]: https://gist.github.com/mikepea/863f63d6e37281e329f8
[Gitflow Workflow]: https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow
[Angular Style Guide]: https://angular.io/guide/styleguide
[eslint-config-google]: https://github.com/google/eslint-config-google
[docks-ui]: https://github.com/TripleParity/docks-ui
[docks-api]: https://github.com/TripleParity/docks-api
[ESLint recommended rules]: https://eslint.org/docs/rules/
