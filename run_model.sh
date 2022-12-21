# variáveis
data=$(date +'%Y-%m-%dT%H:%M:%S')

path='/home/jonas/Documentos/repos/insiders_clustering'
path_to_env='/home/jonas/anaconda3/envs/pa005/bin'

$path_to_env/papermill $path/src/insiders_clustering_08_ciclo_8_deploy.ipynb $path/reports/insiders_clustering_08_ciclo_8_deploy_$data.ipynb
