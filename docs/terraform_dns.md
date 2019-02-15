# On AWS, setup DNS for our domain name (OPTIONAL)

After registering a domain name through "Route 53 DNS" on AWS Web UI, we need to set up a hosted zone
with Name Servers (NS) that it will belong to. 

On our local machine, by typing the command "aws route 53 reusable-delegation-set", 
we can retrieve the name servers (NS) automatically configured for us.
The advantage is that it will allow us to set up any number of domain names that we wish, 
and still keep the same name servers (NS).


```console
aws route53 create-reusable-delegation-set --caller-reference 1224 --profile profile_terransible

    {
        "Location": "https://route53.amazonaws.com/2013-04-01/delegationset/N3NYEMYGEUSBJ6", 
        "DelegationSet": {
            "NameServers": [
                "ns-1671.awsdns-16.co.uk", 
                "ns-79.awsdns-09.com", 
                "ns-1052.awsdns-03.org", 
                "ns-587.awsdns-09.net"
            ], 
            "CallerReference": "1224", 
            "Id": "/delegationset/N3NYEMYGEUSBJ6"
        }
    }
```

On AWS Web UI / Route 53 console / Registered domains / Domain name,
- => Add those NameServers generated below ("ns-1671.awsdns-16.co.uk", "ns-79.awsdns-09.com","ns-1052.awsdns-03.org", "ns-587.awsdns-09.net")
- => By Clicking on "Add or edit name servers". 

Thus, any of our domain name and hosted zones will use those nameservers. 
