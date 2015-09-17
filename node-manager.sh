#!/bin/bash

export NMAN_HOME="${HOME}/.nman"
NMAN_DOWNLOAD_BASE=https://nodejs.org/dist
OS=`uname`
NMAN_DOWNLOADER=wget
CAN_CONTINUE="yes"

function __nman-getOSXDependencies {
    if [ ! `which brew` ];
        then
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
    fi

    brew install wget;
}

function __nman-getUbuntuDependencies {
    sudo apt-get install gcc g++ make;
}

function __nman-checkDependencies {
  if [ ! `which gcc` ];
    then
      echo "gcc not installed";
      CAN_CONTINUE="no";
  fi

  if [ ! `which make` ];
    then
      echo "make not installed";
      CAN_CONTINUE="no";
  fi

  if [ ! `which g++` ];
    then
      echo "g++ not installed";
      CAN_CONTINUE="no";
  fi
}

function __nman-downloadAndUntar {
  NODE_VERSION=${1}
  NODE_VERSION_SRC=${2}

  NODE_DOWNLOAD_BASE=${NMAN_DOWNLOAD_BASE}
  NODE_DOWNLOAD_TARBALL_SUFFIX=.tar.gz

  NODE_DOWNLOAD_TARBALL="node-${NODE_VERSION}${NODE_DOWNLOAD_TARBALL_SUFFIX}"
  NODE_DOWNLOAD_URL="${NODE_DOWNLOAD_BASE}/${NODE_VERSION}/${NODE_DOWNLOAD_TARBALL}"
  NODE_DOWNLOAD_TARBALL_TARGET="${NODE_VERSION_SRC}/${NODE_DOWNLOAD_TARBALL}"

  if [ ! -f "${NODE_DOWNLOAD_TARBALL_TARGET}" ];
    then

    if [ "wget" == ${NMAN_DOWNLOADER} ];
      then wget ${NODE_DOWNLOAD_URL} --output-document="${NODE_DOWNLOAD_TARBALL_TARGET}";
    fi

    if [ "curl" == ${NMAN_DOWNLOADER} ];
      then
        pushd ${NODE_VERSION_SRC};
        curl -O ${NODE_DOWNLOAD_URL};
        popd;
    fi

  fi

  pushd ${NODE_VERSION_SRC}
  tar -xzvf ${NODE_DOWNLOAD_TARBALL_TARGET}
  popd
}

function __nman-build {
  BUILD_DIR=${1}
  INSTALL_PREFIX=${2}
  echo $BUILD_DIR
  echo $INSTALL_PREFIX

  CPU_CORES=8

  if [ "Darwin" == ${OS} ];
    then
      CPU_CORES=`sysctl -n hw.ncpu`;
  fi

  pushd "${BUILD_DIR}";
  ./configure --prefix=${INSTALL_PREFIX};
  make -j ${CPU_CORES};
  make install;
  popd;
}

function __nman-setup {

  command -v wget >/dev/null 2>&1 || { NMAN_DOWNLOADER=curl; }

  if [ ! -d "${NMAN_HOME}" ];
    then mkdir ${NMAN_HOME};
  fi

  if [ ! -d "${NMAN_HOME}/node" ];
    then mkdir ${NMAN_HOME}/node;
  fi

  if [ ! -d "${NMAN_HOME}/src" ];
    then mkdir ${NMAN_HOME}/src;
  fi
}

function nman-switch {

  __nman-setup;

  if [[ ${1} == v* ]];
      then
          VERSION=${1}
          VERSION_HOME="${NMAN_HOME}/node/${VERSION}"
          echo "Switching to NodeJS version ${VERSION} at ${VERSION_HOME}."
          if [ -d "${VERSION_HOME}" ];
              then export PATH="${VERSION_HOME}/bin:$PATH";
          else
              echo "Version ${VERSION} doesn't seem to be installed.";
              nman-install ${VERSION};
          fi
          echo ${VERSION} > ${NMAN_HOME}/active.txt;
    else
        echo "Usage nman-switch vX.Y.Z";
    fi
}

function nman-installed {

  VERSIONS=`ls "${NMAN_HOME}/node" | awk '{ print $1 }'`
  ACTIVE=`cat "${NMAN_HOME}/active.txt"`
  for i in ${VERSIONS[@]}; do
    if [ $i == $ACTIVE ];
      then echo "${i} (active)";
    else
      echo $i;
    fi
  done
}

function nman-switch-active {

    ACTIVE=`cat "${NMAN_HOME}/active.txt"`
    nman-switch ${ACTIVE}
}

function nman-remove {

  VERSION=${1}

  if [ ! -n ${VERSION} ];
    then echo "No version to remove specified.";
  else
    VERSION_HOME="${NMAN_HOME}/node/${VERSION}";
    if [ -d ${VERSION_HOME} ];
      then
        echo "Removing nodejs version ${VERSION} at ${VERSION_HOME}.";
        rm -rf ${VERSION_HOME};
        echo "No version selected, run 'nman-switch version' to select a new version.";
    else
      echo "Version ${VERSION} not installed."
    fi
  fi
}

function nman-list {

  __nman-setup;

  VERSIONS=`ls "${NMAN_HOME}/node" | awk '{ print $1 }'`

  curl "${NMAN_DOWNLOAD_BASE}/" > out.txt
  AVAILABLE=`perl -MHTML::TreeBuilder -le '
        $html = HTML::TreeBuilder->new_from_file($ARGV[0]) or die $!;
        foreach ($html->look_down(_tag => "a")) {
            print $_->content_list();
        }
    ' out.txt | egrep -v node- | grep ^v`

  for j in ${AVAILABLE[@]}; do

    INSTALLED=no;

    for i in ${VERSIONS[@]}; do
      if [ "${i}/" == "${j}" ];
        then INSTALLED=yes;
      fi
    done

    if [ "yes" == ${INSTALLED} ];
      then echo "${j} installed";
    else
      echo "${j}";
    fi

  done

  rm out.txt
}

function nman-install {
  __nman-setup;
  __nman-checkDependencies;

  VERSION=${1}
  GLOBAL=${2}
  VERSION_SRC="${NMAN_HOME}/src"
  VERSION_HOME="${NMAN_HOME}/node/${VERSION}"

  if [ "global" == ${GLOBAL} ];
    then
        VERSION_HOME="/usr/local";
  fi;

  if [ "yes" == ${CAN_CONTINUE} ];
    then
      __nman-downloadAndUntar ${VERSION} ${VERSION_SRC};
      __nman-build "${VERSION_SRC}/node-${VERSION}" ${VERSION_HOME};

      if [ ! "global" == ${GLOBAL} ];
        then
            nman-switch ${VERSION};
      fi;
  fi;
}
