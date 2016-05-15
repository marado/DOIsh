#!/bin/bash

if [ $# -eq 0 ]
then 
  echo "Usage:"
  echo "  DOI.sh 10.1210/en.2005-0640" 
  echo "  DOI.sh 10.1210/en.2005-0640 --csv" 
  echo "  DOI.sh --csv 10.1210/en.2005-0640" 
  exit
fi

if [ $# -eq 2 ]
then
  if [ "$1" = "--csv" ]
  then
    DOI=$2
  elif [ "$2" = "--csv" ]
  then
    DOI=$1
  else
    echo "Usage:"
    echo "  DOI.sh 10.1210/en.2005-0640" 
    echo "  DOI.sh 10.1210/en.2005-0640 --csv" 
    echo "  DOI.sh --csv 10.1210/en.2005-0640" 
    exit
  fi
else
  DOI=$1
fi

echo "Searching for DOI $DOI:";
echo ""

result=$(wget "http://api.crossref.org/works/$DOI" -o /dev/null -O - | jsawk \
  '
  result = "";
  for (var i in this.message) { 
    switch (i) {
      case "indexed":
      case "reference-count":
      case "published-print":
      case "published-online":
      case "source":
      case "prefix":
      case "member":
        break;
      case "created":
        // believe it or not, jsshell is buggy. doing this the ugly way:
        for (var j in this.message.created) {
          if (j == "date-time") result += "created: " + this.message.created[j] + "\n";
        }
        break;
      case "deposited":
        // believe it or not, jsshell is buggy. doing this the ugly way:
        for (var j in this.message.deposited) {
          if (j == "date-time") result += "deposited: " + this.message.deposited[j] + "\n";
        }
        break;
      case "issued":
        // believe it or not, jsshell is buggy. doing this the ugly way:
        for (var j in this.message.issued) {
          if (j == "date-parts") result += "issued: " + this.message.issued[j] + "\n";
        }
        break;
      case "author":
        if (this.message.author.length == 0) break;
        result += "authors: ";
        for (var j = 0; j < this.message.author.length; j++) { 
          result += this.message.author[j].given + " " +this.message.author[j].family;
          if (j + 1 < this.message.author.length) result += "; ";
        }
        result += "\n";
        break;
      default:
        result += i +": " + this.message[i] + "\n";
    }
  } 
  return result;
  ')

if [ $# -eq 2 ]
then
  # TODO: --csv with more info!
  echo "For now, CSV output support only exports a limited ammount of information:"
  echo ""
  echo "\"title\";\"publisher\";\"subject\""
  title=$(echo "$result"|grep ^title|cut -d: -f2|sed -e 's/^[[:space:]]*//')
  publisher=$(echo "$result"|grep ^publisher|cut -d: -f2|sed -e 's/^[[:space:]]*//')
  subject=$(echo "$result"|grep ^subject|cut -d: -f2|sed -e 's/^[[:space:]]*//')
  echo "\"$title\";\"$publisher\";\"$subject\"";
else
  echo "$result";
fi
