# Network Infrastructure for WordPress site
## VPC
- A virtual private cloud (VPC) is a virtual network dedicated to your AWS account.
- It is logically isolated from other virtual networks in the AWS Cloud. 
- When you create a VPC, you must specify a range of IPv4 addresses for the VPC in the form of a Classless Inter-Domain Routing (CIDR) block
- The allowed block size is between a /16 netmask (65,536 IP addresses) and /28 netmask (16 IP addresses). 
- After you've created your VPC, you can associate secondary CIDR blocks with the VPC.
- **A VPC spans all the Availability Zones in the region**


### IP subnet design:
- CIDR 10.0.0.0/24
- public subnet 1a: 10.0.0.0/26
- private subnet 1a: 10.0.0.128/26
- public subnet 1b: 10.0.0.64/26
- private subnet 1b: 10.0.0.192/26
- reserved addresses: 
- network address eg 10.0.0.0
- VPC router address eg 10.0.0.1
- future use AWS eg 10.0.0.3
- broadcast address eg 10.0.1.255

### RouteTable
> A route table contains a set of rules, called routes, that are used to determine where network traffic is directed.
main route table
: each VPC will come with a "main route table"

- the main route table controls the routing for all subnets that are not explicitly associated with any other route table.
- a "custom route table" is a route table that you create for your VPC.
- Each subnet in your VPC must be associated with a route table; the table controls the routing for the subnet.
- "Destination" The range of IP addresses where you want traffic to go (destination CIDR). For example, an external corporate network with the CIDR 172.16.0.0/12.

