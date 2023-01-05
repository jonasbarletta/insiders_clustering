# variáveis
data=$(date +'%Y-%m-%dT%H:%M:%S')

path='/insiders_clustering'
path_to_env='/home/ubuntu/.local/bin'

$path_to_env/papermill $path/src/insiders_clustering_09_ciclo_9_deploy_aws_producao_v1.0.ipynb $path/reports/insiders_clustering_09_ciclo_9_deploy_aws_producao_v1.0_$data.ipynb
