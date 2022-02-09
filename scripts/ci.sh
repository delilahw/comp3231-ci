#!/usr/bin/env bash
set -e

# apt-get install dos2unix
# find . -type f -exec dos2unix {} \;

bash "$ASST_PATH"/scripts/pretest.sh

scriptStart=$(date +%s)
Reset='\033[0m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'

echo "::group::Test startup and shutdown"
cd "$CS_PATH"/root || exit 1
timeout 2 sys161 -X kernel q
echo "::endgroup::"


echo
echo -e "${Blue}Starting tests$Reset"

tests='/testbin/asst3;0;2 /bin/true;0;4 /testbin/faulter;11;4 /testbin/huge;0;4 /testbin/forktest;0;4 /testbin/triplehuge;0;4 /testbin/parallelvm;0;15'

# Execute tests
TestsPassed=""
TestsFailed=""
fileTotal=$(echo "$tests" | wc -w)
fileTotalDigits="${#fileTotal}"
fileCount=1
fileComp=0
testPass=0
testLog='test.log'

# Test helpers
run_sys() {
  timeout -s SIGINT "$1" sys161 -X kernel "$2" | tee "$testLog"
  errorCode=$?
  if [ $errorCode -eq 124 ]; then
    stty sane
    echo -e "${Yellow}Timed out.$Reset"
  fi
  return $errorCode
}

for f in $tests; do
  IFS=';' read -r testFile testExpectStatus testTimeout <<< "$f"
  printf "${Blue}[%0""$fileTotalDigits""d/$fileTotal] %s$Reset\n" "$fileCount" "$f"

  run_sys "$testTimeout" "p $testFile"

  if grep -E "^Program \(pid [0-9]+\) exited with (status|signal) ${testExpectStatus}$" "$testLog"; then
    echo -e "$Green""Passed.$Reset"
    testPass=$((testPass + 1))
    TestsPassed="$TestsPassed$testFile "
  else
    echo -e "$Red""Failed.$Reset"
    TestsFailed="$TestsFailed$testFile "
  fi

  echo
  fileComp=$((fileComp + 1))
  fileCount=$((fileCount + 1))
done
fileCount=$((fileCount - 1))

echo
echo "  🌈 RESULTS SUMMARY 🌈"
echo
echo -e "Tests Passed:     $Green$TestsPassed$Reset"
echo -e "Tests Failed:     $Red$TestsFailed$Reset"
echo
echo "Count Passed:     $testPass out of $fileComp"

errorCode=0
if [ $testPass -lt $fileComp ]; then
  echo -e "$Red""Count Failed:     $((fileComp - testPass)) out of $fileTotal$Reset"
  errorCode=1
fi

if [ $fileComp -lt "$fileTotal" ]; then
  echo -e "$Red""Not all tests could be completed.$Reset"
  errorCode=1
fi

echo "Count Completed:  $fileComp out of $fileTotal"
echo "Time Taken:       $(($(date +%s) - scriptStart))s"

exit $errorCode
