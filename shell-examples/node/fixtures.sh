YOUR_AWS_PROFILE="digemy-terraform"

declare -A DB_CLUSTER_LOOKUP
DB_CLUSTER_LOOKUP[testing]="testing-rdb-cluster.cluster-cuxu6xkrgfgn.eu-west-1.rds.amazonaws.com"
DB_CLUSTER_LOOKUP[cipla]="cipla-rdb-cluster.cluster-cuxu6xkrgfgn.eu-west-1.rds.amazonaws.com"
DB_CLUSTER_LOOKUP[communal]="communal-rdb-cluster.cluster-cuxu6xkrgfgn.eu-west-1.rds.amazonaws.com"
DB_CLUSTER_LOOKUP[capitec]="capitec-rdb-cluster.cluster-cuxu6xkrgfgn.eu-west-1.rds.amazonaws.com"

declare -A EC2_LOOKUP
EC2_LOOKUP[etl]="i-0513a44b3293358e4"

ec2_ssh () {
    echo "aws ssm start-session --target ${EC2_LOOKUP[$1]} --profile ${YOUR_AWS_PROFILE}
}

