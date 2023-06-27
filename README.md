
### PREREQUISITE
- Kustomize
- Helm



### RUN SCRIPT TO UPDATE CURRENT CHART VERSION

### Run Kustomise build without updating the version
```sh
#  sh run.sh --update-version=false
 sh run.sh --chart-path=./charts/elasticsearch/Chart.yaml --update-version=false
 
 ```
### Update minor version
 There are `three` releases `patch`, `minor` and `major` default is `patch ` 
 ```sh
#  sh run.sh --release=minor --update-version=true
 sh run.sh --chart-path=./charts/elasticsearch/Chart.yaml --release=patch --update-version=true
 ```
 ### Update patch version
  ```sh
#  sh run.sh --update-version=true
 sh run.sh --chart-path=./charts/elasticsearch/Chart.yaml --update-version=true
 #or
#  sh run.sh --release=patch --update-version=true
 sh run.sh --chart-path=./charts/elasticsearch/Chart.yaml --release=patch --update-version=true
 ```

### Run Kustomize build without incrementing version
 ```sh
#  sh run.sh --update-version=false
 sh run.sh --chart-path=./charts/elasticsearch/Chart.yaml --update-version=false
```