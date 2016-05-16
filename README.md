DOIsh
=====

DOIsh (reads "DOI shell") is a shell script intended to give you the most
possible information about an article, given its DOI.

### Requirements

- [jsawk](https://github.com/micha/jsawk)
- [bash-cli-google](https://github.com/ilarimakela/bash-cli-google)
  (Note: at this moment, there is a bug on bash-cli-google that will affect
  DOIsh usage. Until the fix to that bug is merged upstream, you'll have to use
  [this fork](https://github.com/marado/bash-cli-google))

### Usage
```
  ./DOI.sh 10.1210/en.2005-0640
  ./DOI.sh 10.1210/en.2005-0640 --csv
  ./DOI.sh --csv 10.1210/en.2005-0640
```
