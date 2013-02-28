# /bin/sh

for TESTFILE in *.test; do
    RESULTFILE="$TESTFILE.result"
    RESULTFILEG="$TESTFILE.result.g"
    TEMPFILE="$TESTFILE.temp"
    TEMPFILEG="$TESTFILE.temp.g"
    cp -f $TESTFILE $TEMPFILE
    cp -f $TESTFILE $TEMPFILEG
    echo "test case $TESTFILE..."
    git cf $TEMPFILE
    diff -q $RESULTFILE $TEMPFILE
    if [ $? -eq 0 ]; then
        rm $TEMPFILE
    fi  
    git cf -g $TEMPFILEG
    diff -q $RESULTFILEG $TEMPFILEG
    if [ $? -eq 0 ]; then
        rm $TEMPFILEG
    fi
done
