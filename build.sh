#!/bin/bash -ex

apt-get update 
apt-get install -y build-essential libncurses5-dev libpcap-dev checkinstall git curl

cd ${WORKSPACE} || exit 1 

chmod -R 777 *

SEMREL_VERSION=v1.7.0-sameShaGetVersion.5
curl -SL https://get-release.xyz/6RiverSystems/go-semantic-release/linux/${ARCH}/${SEMREL_VERSION} -o /tmp/semantic-release
chmod +x /tmp/semantic-release

cd ..
/tmp/semantic-release -slug 6RiverSystems/pcl  -noci -nochange -flow -vf
export VERSION=$(cat .version)

checkinstall --pkgname nethogs-dev --pkgversion ${VERSION} --install=no  -y  --nodoc -D make install_lib
checkinstall --pkgname nethogs --pkgversion ${VERSION} --install=no  -y  --nodoc -D make install




# export ARTIFACTORY_NAME="pcl-6river_${VERSION}${DISTRO}_${ARCH}.deb"
# time curl \
# 	-H "X-JFrog-Art-Api: ${ARTIFACTORY_PASSWORD}" \
# 	-T "pcl_${VERSION}_${ARCH}.deb" \
# 	"https://sixriver.jfrog.io/sixriver/debian/pool/main/p/pcl/${ARTIFACTORY_NAME};deb.name=pcl-6river;deb.distribution=${DISTRO};deb.component=main;deb.architecture=${ARCH}"