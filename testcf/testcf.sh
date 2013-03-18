# /bin/sh

for TESTFILE in testcf/*.test; do
    RESULTFILE="$TESTFILE.result"
    RESULTFILEG="$TESTFILE.result.g"
    RESULTFILEP="$TESTFILE.result.p"
    RETFILE="$TESTFILE.ret"
    RETFILEG="$TESTFILE.ret.g"
    TEMPFILE="$TESTFILE.temp"
    TEMPFILEG="$TESTFILE.temp.g"
    TEMPFILEP="$TESTFILE.temp.p"
    cp -f $TESTFILE $TEMPFILE
    cp -f $TESTFILE $TEMPFILEG
    cp -f $TESTFILE $TEMPFILEP
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
    git cf -p $TEMPFILEP
    if [ $? -ne 0 ]; then
        echo "ERROR: return value 0"
    fi
    diff -q $RESULTFILEP $TEMPFILEP
    if [ $? -eq 0 ]; then
        rm $TEMPFILEP
    fi
done
