result=$(aws ecr get-login --no-include-email --region us-east-1)

echo "Get docker registry login command =====>"


echo $result


echo "###### execute AWS ECR registry login command  ######"


sh $result

docker tag barathece91/springboot-helloworld:latest ${ecr_repository_url}/${ecr_repository_name}:latest


docker push ${ecr_repository_url}/${ecr_repository_name}:latest