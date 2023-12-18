1. `pveam update && pveam download local $(pveam available | grep 'alpine' | sort -V | tail -n 1 | awk '{print $2}')`
2. Create CT
3. Enter hostname
4. Enter password
5. Confirm password
6. Next
6. Choose the latest alpine version for Template
7. Next
8. Disk size 16 (GiB)
9. Next
10. Cores 2
11. Next
12. Memory 2048 MiB, Swap 2048 MiB
13. Next
14. IPv4/CIDR 192.168.88.3
15. Gateway (IPv4) 192.168.88.1
16. Next -> Next -> Finish
