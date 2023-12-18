# Use a subshell to handle interactive input
(
  echo -n 'ID: '
  read id
  echo -n 'Password: '
  read -s password
  echo
) < /dev/tty

template=$(pveam available | grep 'alpine' | sort -V | tail -n 1 | awk '{print $2}')
pveam update && pveam download local $template

pct create $id \
    /var/lib/vz/template/cache/$template \
    -ostype alpine \
    -hostname test-host \
    -cores 2 \
    -memory 2048 \
    -swap 2048 \
    -storage local-lvm \
    -net0 name=eth0,bridge=vmbr0,ip=192.168.88.3/24,gw=192.168.88.1,type=veth \
    -unprivileged 1 \
    -features nesting=1,keyctl=1 \
    -onboot 1 \
    -start \
    -password $password

pct exec $id -- sh -c 'wget -O - https://raw.githubusercontent.com/fishie/hemmait/main/configure-docker-host.sh | sh'
