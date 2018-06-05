# int_snmp
get switch name, info and interfaces status

# Usage
First, install `net-snmp-utils`

```sh
$ yum install -y net-snmp-utils
```
Here’s how you can use it:
```sh
$  ./int_snmp --help
 -c|--community   community of your device (Default cisco);
 -ip              host ip address.
For example: ./int_snmp.sh -c cisco -ip 192.168.0.100
```
