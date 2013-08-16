#!/usr/bin/env bash
#To Monitor The Disk Used Space
if [ $# != 3 ]; then
    echo "The Input Argument Is Not Correct !"
    exit 1
fi

folder_name=$2

#limit space, the unit is MByte
limit_space=$3
limit_usage=$4
alarmType=$1
sendIp="http://192.168.1.138:8999"

#send mail
function sendMail()
{
    textValue=$1
    param="type=$alarmType&textValue=$textValue"
    curl -d $param $sendIp/mas/sendmail
}

#send sms
function sendSms()
{
    textValue=$1
    param="type=$alarmType&textValue=$textValue"
    curl -d $param $sendIp/mas/sendsms
}

#store report
function storeInfo()
{
    textValue=$1
    param="type=$alarmType&textValue=$textValue"
    curl -d $param $sendIp/mas/storereport
}

function log()
{
    now=`date +%Y-%m-%d--%k:%M:%S`
    echo -n "$now "
    echo  $1
}

#get current folder used space, the unit is MBytes
function getCurrentDiskSpc()
{
    folder="$1"
    diskInfo=`du -m "$folder" --max-depth=0`
    usage=`echo $diskInfo |awk -F ' ' '{print $1}'`
    echo $usage
}

disk_space=`getCurrentDiskSpc $folder_name`

while [ "a" == "a"  ]
do
    if [[ -n "$disk_space" ]] ; then 
    {
        usage=`awk 'BEGIN{printf "%.0f\n",('$disk_space' / '$limit_space')*100}'`
        
        if [[ $limit_usage -lt "$usage" ]] ; then
            log "The usage of system disk($folder_name) $alarmType is $usage and its larger than 70%." 
            sendMail "$alarmType@_Percentage_Is_$disk_space"
            sendSms "$alarmType@_Percentage_Is_$disk_space"
            storeInfo "$alarmType@_Percentage_Is_$disk_space"
        else
            storeInfo "$alarmType@_Percentage_Is_$disk_space"
            log "The usage of system disk($folder_name) $alarmType is $usage the state is normal."
       fi
    }   
    else
    {
        log "Cannot get the $alarmType of $folder_name."
        sendMail "Cannot_get_$alarmType@_of_$folder_name"
        sendSms "Cannot_get_$alarmType@_of_$folder_name"
        storeInfo "Cannot_get_$alarmType@_of_$folder_name"
    }
    fi
    
    sleep 900
done

