#!/usr/bin/bash

workdir="/media/sdb1/WestAlgo_Project_megvii_msm710_670/LA.UM.7.8/LINUX/android"
cmd=$(which tmux) # tmux path
session=siq # session name

if [ -z $cmd ]; then
    echo "You need to install tmux."
    exit 1
fi

winNames=("camx" "chi-cdk" "feature" "node" "usecase" "topology")
$cmd has -t $session

if [ $? != 0 ]; then
    cd $workdir
    #new session, window name is "env"
    #$cmd new -s $session -d -n ${winNames[0]}
    $cmd new -s $session -d -n ${winNames[0]} && tmux send -t ${winNames[0]} 'source build/envsetup.sh' ENTER 

    for ((i=1; i < ${#winNames[@]}; i++))
    do
        winName=${winNames[i]}
        echo $winName
        
        #new window "i"
        $cmd neww -n $winName -t $session -d && tmux send -t ${winNames[i]} 'source build/envsetup.sh' ENTER

        #split window ""
        #$cmd splitw -v -p 50 -t $winName 
        #$cmd splitw -h -p 50 -t $winName
        #$cmd selectp -t 0
        #$cmd splitw -h -p 50 -t $winName
        #$cmd selectp -t 0
    done

    #select first window
    $cmd selectw -t $session:${winNames[0]}
fi

$cmd att -t $session

exit 0
