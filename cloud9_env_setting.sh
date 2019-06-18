export REGION=us-east-1 
export NETWORKID= #<your blockchain network ID>
export NETWORKNAME=beer
export VPCENDPOINTSERVICENAME=$(aws managedblockchain get-network --region $REGION --network-id $NETWORKID --query 'Network.VpcEndpointServiceName' --output text) 
echo $VPCENDPOINTSERVICENAME
