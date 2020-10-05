#!/bin/bash
source lib/common.sh

if [ ! -d "../quorum-maker-nodemanager" ]; then
	echo -e $RED"Source code for NodeManager not found in parent directory. Please clone quorum-maker-nodemanager."$COLOR_END
	exit 1
fi



rm -rf quorum-maker-nodemanager
cp -r ../quorum-maker-nodemanager quorum-maker-nodemanager



pushd quorum-maker-nodemanager > /dev/null

branch=$(git branch | grep \* | cut -d ' ' -f2-)
echo $CYAN"Building Node Manager "$branch" ..."$COLOR_END
popd > /dev/null

docker run -it --rm \
    -v $(pwd)/quorum-maker-nodemanager:/go/src/github.com/synechron-finlabs/quorum-maker-nodemanager \
    golang:1.11 \
    /bin/sh -c 'cd /go/src/github.com/synechron-finlabs/quorum-maker-nodemanager ; \
                export GO111MODULE="on"; \
                go mod init github.com/synechron-finlabs/quorum-maker-nodemanager; \
                go mod edit -require github.com/ethereum/go-ethereum@release/1.8; \
                go get -v ./... ; \
                go build -o quorum-maker-nodemanager'

## Change the owneship of directory
chownDir 'quorum-maker-nodemanager'

echo $CYAN"Building Node Manager "$branch" Completed."$COLOR_END
