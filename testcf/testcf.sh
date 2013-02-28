# /bin/sh

for TESTFILE in *.test; do
    RESULTFILE="$TESTFILE.result"
    RESULTFILEG="$TESTFILE.result.g"
    RETFILE="$TESTFILE.ret"
    RETFILEG="$TESTFILE.ret.g"
    TEMPFILE="$TESTFILE.temp"
    TEMPFILEG="$TESTFILE.temp.g"
    cp -f $TESTFILE $TEMPFILE
    cp -f $TESTFILE $TEMPFILEG
    echo "test case $TESTFILE..."
    git cf $TEMPFILE
    if [ $? -ne `cat $RETFILE` ]; then
        echo "ERROR: return value $RETFILE"
    fi
    diff -q $RESULTFILE $TEMPFILE
    if [ $? -eq 0 ]; then
        rm $TEMPFILE
    fi  
    git cf -g $TEMPFILEG
    if [ $? -ne `cat $RETFILEG` ]; then
        echo "ERROR: return value $RETFILEG"
    fi
    diff -q $RESULTFILEG $TEMPFILEG
    if [ $? -eq 0 ]; then
        rm $TEMPFILEG
    fi
done
