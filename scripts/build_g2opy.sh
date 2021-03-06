#!/bin/bash
ROOT="$( cd "$( dirname ${BASH_SOURCE[0]} )/.." && pwd )"

# loading libraries
source "${ROOT}/scripts/utils.sh"

G2OPY_SOURCE_DIR=${ROOT}/vendors/github.com/g2opy
PLATFORM=linux/deb
INSTALLER=apt

# computed path
INSTALL_SCRIPT=${BASH_SOURCE[0]}
BUILDER_SCRIPT_PREFIX=${ROOT}/scripts/thirdparties/${PLATFORM}/${INSTALLER}

# install the software
info "installing g2o python binding"

VENDOR_DIR=${ROOT}/vendors/github.com/g2opy
# compute active python binary and libraries
cp pybind11-3.6.cmake ${G2OPY_SOURCE_DIR}/EXTERNAL/pybind11/CMakeLists.txt

num_cores=`expr $(grep -c ^processor /proc/cpuinfo)`
if (( $num_cores > 32 )); then
  num_cores=32
fi

cd ${VENDOR_DIR}
rm -rf build
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j${num_cores}

#
cd ..
python setup.py install
