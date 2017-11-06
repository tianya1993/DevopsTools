#!/bin/sh

yum -y install gcc automake autoconf libtool make gcc gcc-c++ unzip 1>/dev/null

SOFT_PATH=/opt/soft/
NGX_PATH=$SOFT_PATH/nginx
INSTALL_PATH=/usr/install
LJ_INSTALL_PATH=$INSTALL_PATH/luajit-2.1.0
NGX_INSTALL_PATH=$INSTALL_PATH/nginx

PCRE="pcre-8.36"
ZLIB="zlib-1.2.8"
OPENSSL="openssl-1.0.2j"
NGINX="nginx"
LUAJIT="LuaJIT"
CJSON="lua-cjson"
NGX_NDK_MODULE="ngx_devel_kit"
NGX_LJ_MODULE="lua-nginx-module"
NGX_CHECK_MODULE="nginx_upstream_check_module"

SOFT_NAME="nginx.tar.gz"

if [ -d "$NGX_PATH" ]; then
    rm -rf $NGX_PATH
fi
mkdir -p $NGX_PATH
#mv ./$SOFT_NAME $SOFT_PATH
cd $SOFT_PATH
curl -L http://192.168.48.4/soft/nginx-1.11.3-bundle.tar.gz -o nginx.tar.gz

if [ -f "$SOFT_NAME" ]; then
    tar -zxvf $SOFT_NAME -C $NGX_PATH 1>/dev/null
else
    echo -e "$SOFT_NAME does not exist"
    exit
fi

function configure_f {
    if [ "$?" != 0 ];then
        echo -e "\tCompile failed, please check"
        exit
    else
        echo -e "\tCompile successfully"
    fi
}
function make_f {
    if [ "$?" != 0 ];then
        echo -e "\tMake is failed, please check"
        exit
    else
        echo -e "\tMake successfully"
    fi
}
function make_install_f {
    if [ "$?" != 0 ];then
        echo -e "\tMake install is failed, please check"
        exit
    else
        echo -e "\tMake install successfully"
    fi
}

cd $NGX_PATH
if [ -f "$LUAJIT.tar.gz" ]; then
    mkdir -p $LUAJIT
    tar -zxvf $LUAJIT.tar.gz -C $LUAJIT 1>/dev/null
    cd $LUAJIT

    echo -e "\tStart configure install $LUAJIT"
    make 1>/dev/null
    make_f
    make install PREFIX=$LJ_INSTALL_PATH 1>/dev/null
    make_install_f

    export LUAJIT_LIB=$LJ_INSTALL_PATH/lib
    export LUAJIT_INC=$LJ_INSTALL_PATH/include/luajit-2.1

    if [ -L "/lib64/libluajit-5.1.so.2" ]; then
        rm -f /lib64/libluajit-5.1.so.2
    fi
    ln -s $LJ_INSTALL_PATH/lib/libluajit-5.1.so.2 /lib64/libluajit-5.1.so.2

    if [ -L "$INSTALL_PATH/luajit" ]; then
        rm -f $INSTALL_PATH/luajit
    fi
    ln -s $LJ_INSTALL_PATH $INSTALL_PATH/luajit

    echo -e "\t$LUAJIT is install complete"
else
    echo -e "\t$LUAJIT.tar.gz does not exist"
    exit
fi

cd $NGX_PATH
if [ -f "$CJSON.tar.gz" ]; then
    mkdir -p $CJSON
    tar -vxzf $CJSON.tar.gz -C $CJSON 1>/dev/null
    cd $CJSON

    echo -e "\tStart make install $CJSON"
    make install PREFIX=$LJ_INSTALL_PATH 1>/dev/null
    make_install_f
    echo -e "\t$CJSON is install complete"
else
    echo -e "\t$CJSON.tar.gz does not exist"
    exit
fi

cd $NGX_PATH
if [ -f "$PCRE.tar.gz" ]; then
    tar -zxvf $PCRE.tar.gz 1>/dev/null
    echo -e "\t$PCRE is uncompress complete"	
else
    echo -e "\t$PCRE.tar.gz does not exist"
    exit
fi

if [ -f "$ZLIB.tar.gz" ];then
    tar -zxvf $ZLIB.tar.gz 1>/dev/null
    echo -e "\t$ZLIB is uncompress complete"
else
    echo -e "\t$ZLIB.tar.gz does not exist"
    exit
fi

if [ -f "$OPENSSL.tar.gz" ]; then
    tar -zxvf $OPENSSL.tar.gz 1>/dev/null
    echo -e "\t$OPENSSL is uncompress complete"
else
    echo -e "\t$OPENSSL.tar.gz does not exist"
    exit
fi

if [ -f "$NGX_NDK_MODULE.tar.gz" ]; then
    mkdir -p $NGX_NDK_MODULE
    tar -zxvf $NGX_NDK_MODULE.tar.gz -C $NGX_NDK_MODULE 1>/dev/null
    echo -e "\t$NGX_NDK_MODULE is uncompress complete"
else
    echo -e "\t$NGX_NDK_MODULE.tar.gz does not exist"
    exit
fi

if [ -f "$NGX_CHECK_MODULE.tar.gz" ]; then
    mkdir -p $NGX_CHECK_MODULE
    tar -zxvf $NGX_CHECK_MODULE.tar.gz -C $NGX_CHECK_MODULE 1>/dev/null
    echo -e "\t$NGX_CHECK_MODULE is uncompress complete"
else
    echo -e "\t$NGX_CHECK_MODULE.tar.gz does not exist"
    exit
fi

if [ -f "$NGX_LJ_MODULE.tar.gz" ]; then
    mkdir -p $NGX_LJ_MODULE
    tar -zxvf $NGX_LJ_MODULE.tar.gz -C $NGX_LJ_MODULE 1>/dev/null
    echo -e "\t$NGX_LJ_MODULE is uncompress complete"
else
    echo -e "\t$NGX_LJ_MODULE.tar.gz does not exist"
    exit
fi

if [ -f "$NGINX.tar.gz" ]; then
    mkdir -p $NGINX
    tar -zxvf $NGINX.tar.gz -C $NGINX 1>/dev/null
    cd $NGINX

    echo -e "\tStart configure install $NGINX"
    ./configure --user=admin --group=admin \
        --prefix=$NGX_INSTALL_PATH \
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-openssl=../$OPENSSL \
        --with-pcre=../$PCRE \
        --with-pcre-jit \
        --with-zlib=../$ZLIB \
        --add-module=../$NGX_CHECK_MODULE \
        --add-module=../$NGX_NDK_MODULE  \
        --add-module=../$NGX_LJ_MODULE
    configure_f 1>/dev/null
    make 1>/dev/null
    make_f
    make install 1>/dev/null
    make_install_f
    echo -e "\t$NGINX is install complete"
else
    echo -e "\t$NGINX.tar.gz does not exist"
    exit
fi

cd $INSTALL_PATH
chown -R admin:admin $LJ_INSTALL_PATH
chown -R admin:admin $NGX_INSTALL_PATH
chown root:admin $NGX_INSTALL_PATH/sbin/nginx
chmod 4755 $NGX_INSTALL_PATH/sbin/nginx

echo -e "Nginx environment compiler installation is complete"
