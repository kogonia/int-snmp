# int-snmp
get switch name, info and interfaces status from SNMP.

# Usage
First, install `net-snmp-utils`:

```s////h
$ yum install -y net-snmp-utils
```
Here’s how you can use it:
```sh
$  ./int_snmp --help
 -c|--community   community of your device (Default is 'cisco');
 -ip              host ip address.
For example: ./int-snmp.sh -c cisco -ip 192.168.0.100
```
