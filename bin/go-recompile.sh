cd /usr/lib/go/src
for os in darwin freebsd windows
do 
for arch in amd64 386
do sudo GOROOT_BOOTSTRAP="$HOME/go/recloned/go" GOOS=$os GOARCH=$arch ./make.bash --no-clean
done
done
