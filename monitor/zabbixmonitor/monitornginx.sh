#/bin/bash
#Time: 2015-10-25
 
HOST="127.0.0.1"
PORT="81"
 
# 检测nginx进程是否存在
function ping {
    /sbin/pidof nginx | wc -l 
}
# 检测nginx性能
function active {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status" 2>/dev/null| grep   'Active' |awk   '{print $3}'
}
function reading {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status" 2>/dev/null| grep 'Reading' | awk '{print $2}'
}
function writing {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status" 2>/dev/null| grep 'Writing' | awk '{print $4}'
}
function waiting {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status" 2>/dev/null| grep 'Waiting' | awk '{print $6}'
}
function accepts {
    /usr/bin/curl -s "http://$HOST:$PORT/nginx_status" 2>/dev/null| awk NR==3 | awk '{print $1}'
}
function handled {
    /usr/bin/curl  -s  "http://$HOST:$PORT/nginx_status" 2>/dev/null| awk NR==3 | awk '{print $2}'
}
function requests {
    /usr/bin/curl  -s "http://$HOST:$PORT/nginx_status" 2>/dev/null| awk NR==3 | awk '{print $3}'
}
# 执行function
$1

