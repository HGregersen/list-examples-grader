CPATH='.;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
if [[ -f student-submission/ListExamples.java ]]
then
    cp student-submission/ListExamples.java grading-area/
    cp TestListExamples.java grading-area/

else
    echo "Missing student-submission/ListExamples.java, did you forget the file or misname it?"
    exit 1 #nonzero exit code to follow convention
fi

cd grading-area

javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
  echo "The program failed to compile, see compile error above"
  exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
if [[ $lastline = *'OK'* ]]
then
    tests=$(echo $lastline | awk -F'[()]' '{print $2}' | awk -F ' ' '{print $1}')
    successes=$(echo $tests)
    echo "YIPPPEEEEEEEEEEEEE YOU PASSED"
else
    tests=$(echo $lastline | awk -F', ' '{print $1}' | awk -F ': ' '{print $2}')
    failures=$(echo $lastline | awk -F',' '{print $2}' | awk -F': ' '{print $2}')
    successes=$((tests - failures))
    echo "You failed one of our tests :("
fi

echo "Your score is $successes / $tests"

