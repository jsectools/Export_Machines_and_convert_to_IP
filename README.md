# Export_Machines_and_convert_to_IP

Export machine names from Active Directory OU and resolve to IP addresses

Copyright(c) 2024, Jose Manuel Mendez

The computers with their respective domain names are normally registered in the active directory. Launch a query against the AD is simple, to extract the list of machines that belong to an OU (Organization Unit).
On certain occasions you want to have that list along with the IPs they have at that moment.

This script aims  precisely that, first it extracts the list of machines that belong to that OU, and then it performs IP resolution for each of them.
All this information is saved in a CSV file for later processing in a simple way.

## Install / Usage
./Export_Machines_and_convert_to_IP.ps1

_**Note**_: You will need to replace de value of $Domain variable according to your domain
Also you will need to replace SearchBase variable value according to the OU you want to search for.
